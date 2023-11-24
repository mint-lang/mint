require "uri"

module Mint
  class Compiler2
    # This is a Virtual DOM renderer for markdown using Markd shard.
    #
    # The AST for the markdown is a tree where each node refers to the parent
    # node, next sibling and previous sibling.
    #
    # We walk the nodes and create a tree of nodes and then using the JavaScript
    # builder to render them.
    class VDOMRenderer2
      def self.render(
        *,
        replacements : Array(Compiled),
        highlight : Bool? = nil,
        document : Markd::Node,
        separator : String,
        js : Js
      ) : Compiled
        render(
          node: self.new.render(document, separator, highlight),
          replacements: replacements,
          separator: separator,
          js: js)
      end

      def self.render(
        replacements : Array(Compiled),
        node : Node | String,
        separator : String,
        js : Js
      ) : Compiled
        case node
        in String
          if node == separator
            replacements.shift
          else
            js.string(node.gsub("\\", "\\\\"))
          end
        in Node
          attributes =
            node
              .attributes
              .transform_values { |value| [%("#{value}")] of Item }

          children =
            node.children.map do |item|
              render(
                replacements: replacements,
                separator: separator,
                node: item,
                js: js)
            end

          tag =
            case node.tag
            in Builtin
              node.tag
            in String
              %('#{node.tag}')
            end

          js.call(Builtin::CreateElement, [
            [tag] of Item,
            js.object(attributes),
            js.array(children),
          ])
        end
      end

      class Node
        getter attributes : Hash(String, String)
        getter children : Array(Node | String)
        getter tag : Builtin | String

        def initialize(
          @tag : Builtin | String, *,
          @attributes = {} of String => String,
          @children = [] of Node | String
        )
        end
      end

      HEADINGS = %w(h1 h2 h3 h4 h5 h6)

      getter stack : Array(Node) = [] of Node

      def render(document : Markd::Node, separator : String, highlight : Bool?)
        walker =
          document.walker

        while event = walker.next
          node, entering = event

          # If we are in a list we don't add a <p> tag if all the list
          # items have only one paragraph (that what "thight" is).
          next if (grand_parent = node.parent?.try &.parent?) &&
                  node.type == Markd::Node::Type::Paragraph &&
                  grand_parent.type.list? &&
                  grand_parent.data["tight"]

          if entering
            # Construct the node from the Markd::Node
            item =
              case node.type
              in Markd::Node::Type::Document      then Node.new(Builtin::Fragment)
              in Markd::Node::Type::BlockQuote    then Node.new("blockquote")
              in Markd::Node::Type::Strong        then Node.new("strong")
              in Markd::Node::Type::Emphasis      then Node.new("em")
              in Markd::Node::Type::Item          then Node.new("li")
              in Markd::Node::Type::ThematicBreak then Node.new("hr")
              in Markd::Node::Type::LineBreak     then Node.new("br")
              in Markd::Node::Type::Paragraph     then Node.new("p")
              in Markd::Node::Type::Heading
                Node.new(HEADINGS[node.data["level"].as(Int32) - 1])
              in Markd::Node::Type::Code
                Node.new("code", children: [
                  node.text.strip,
                ] of Node | String)
              in Markd::Node::Type::Link
                Node.new("a", attributes: {
                  "href"  => node.data["destination"].as(String),
                  "title" => node.data["title"].as(String).presence,
                }.compact)
              in Markd::Node::Type::Image
                Node.new("img", attributes: {
                  "src" => node.data["destination"].as(String),
                  "alt" => node.first_child.text,
                })
              in Markd::Node::Type::List
                attributes =
                  {} of String => String

                if start = node.data["start"].as(Int32)
                  attributes["start"] = start.to_s unless start == 1
                end

                Node.new(
                  node.data["type"] == "bullet" ? "ul" : "ol",
                  attributes: attributes)
              in Markd::Node::Type::CodeBlock
                languages =
                  node.fence_language.try(&.split)

                language =
                  languages.try(&.first?).try(&.strip.presence)

                attributes =
                  {} of String => String

                attributes["class"] =
                  "language-#{language}" if language

                children =
                  if highlight
                    if language == "mint"
                      parser = Parser.new(node.text.strip, "source.mint")
                      parser.parse_any

                      unless parser.ast.nodes.empty?
                        Compiler2
                          .tokens_to_lines(parser.ast)
                          .map do |parts|
                            items =
                              parts.map do |part|
                                case part
                                in String
                                  part
                                in Tuple(SemanticTokenizer::TokenType, String)
                                  Node.new("span",
                                    attributes: {"className" => part[0].to_s.underscore},
                                    children: [part[1]] of Node | String)
                                end
                              end

                            Node.new("span",
                              attributes: {"className" => "line"},
                              children: items).as(Node | String)
                          end
                      end
                    end || begin
                      node
                        .text
                        .strip
                        .split("\n").map do |part|
                        Node.new("span",
                          attributes: {"className" => "line"},
                          children: [part] of Node | String
                        ).as(Node | String)
                      end
                    end
                  else
                    [node.text.strip] of Node | String
                  end

                Node.new("pre", children: [
                  Node.new("code",
                    attributes: attributes,
                    children: children),
                ] of Node | String)
              in Markd::Node::Type::HTMLInline,
                 Markd::Node::Type::HTMLBlock,
                 Markd::Node::Type::Text
                next if (parent = node.parent?) && parent.type.image?
                node.text
              in Markd::Node::Type::SoftBreak
                "\n"
              in Markd::Node::Type::CustomInLine,
                 Markd::Node::Type::CustomBlock
              end

            # Push the node to the children of the parent element (the last one
            # we entered).
            case item
            when String
              unless item.empty?
                if item.includes?(separator)
                  items =
                    item.split(separator).intersperse(separator)

                  stack.last?.try(&.children.concat(items))
                else
                  stack.last?.try(&.children.push(item))
                end
              end
            when Node
              stack.last?.try(&.children.push(item))
            end

            # If there is a new block node we push it to the end of the stack,
            # so the children can be added there.
            case item
            when Node
              if !node.type.in?(
                   Markd::Node::Type::ThematicBreak,
                   Markd::Node::Type::LineBreak,
                   Markd::Node::Type::CodeBlock,
                   Markd::Node::Type::Code)
                stack.push(item)
              end
            end
          else
            # When leaving we remove the current node from the end of the stack,
            # but keep at least one, which will be returned in the end.
            case node.type
            when Markd::Node::Type::ThematicBreak,
                 Markd::Node::Type::BlockQuote,
                 Markd::Node::Type::Paragraph,
                 Markd::Node::Type::CodeBlock,
                 Markd::Node::Type::Emphasis,
                 Markd::Node::Type::Document,
                 Markd::Node::Type::Heading,
                 Markd::Node::Type::Strong,
                 Markd::Node::Type::Image,
                 Markd::Node::Type::Item,
                 Markd::Node::Type::Code,
                 Markd::Node::Type::Link,
                 Markd::Node::Type::List
              stack.pop if stack.size > 1
            end
          end
        end

        # There always will be a node since we only render whole documents.
        stack.first
      end
    end
  end
end
