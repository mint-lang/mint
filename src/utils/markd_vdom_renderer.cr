require "uri"

module Mint
  # This is a Virtual DOM renderer for markdown using Markd shard.
  #
  # The AST for the markdown is a tree where each node refers to the parent
  # node, next sibling and previous sibling.
  #
  # We walk the nodes and create a tree of nodes and then using the JavaScript
  # builder to render them.
  class VDOMRenderer
    enum Highlight
      MintOnly
      None
      All
    end

    def self.render(
      *,
      highlight : Highlight = Highlight::None,
      replacements : Array(Compiler::Compiled),
      document : Markd::Node,
      separator : String,
      js : Compiler::Js,
    ) : Compiler::Compiled
      render(
        node: self.new.render(document, separator, highlight),
        replacements: replacements,
        separator: separator,
        js: js)
    end

    def self.render_html(
      *,
      highlight : Highlight = Highlight::None,
      replacements : Array(String),
      document : Markd::Node,
      separator : String,
    )
      root =
        self.new.render(document, separator, highlight)

      processor = uninitialized Node | String, HtmlBuilder -> Nil
      processor = ->(node : Node | String, builder : HtmlBuilder) do
        case node
        in String
          builder.text node
        in Node
          tag =
            case item = node.tag
            in Compiler::Builtin
              raise "WTF"
            in String
              item
            end

          builder.tag(tag, node.attributes) do
            node.children.each do |child|
              processor.call(child, builder)
            end
          end
        end
      end

      XML.build_fragment(indent: nil) do |xml|
        builder = HtmlBuilder.new(xml)
        root.children.each do |child|
          processor.call(child, builder)
        end
      end.strip
    end

    def self.render(
      replacements : Array(Compiler::Compiled),
      node : Node | String,
      separator : String,
      js : Compiler::Js,
    ) : Compiler::Compiled
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
            .transform_values { |value| [%("#{value}")] of Compiler::Item }

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
          in Compiler::Builtin
            node.tag
          in String
            %('#{node.tag}')
          end

        js.call(Compiler::Builtin::CreateElement, [
          [tag] of Compiler::Item,
          js.object(attributes),
          js.array(children),
        ])
      end
    end

    class Node
      property children : Array(Node | String)
      getter attributes : Hash(String, String)
      getter tag : Compiler::Builtin | String

      def initialize(
        @tag : Compiler::Builtin | String, *,
        @attributes = {} of String => String,
        @children = [] of Node | String,
      )
      end
    end

    HEADINGS = %w[h1 h2 h3 h4 h5 h6]

    getter stack : Array(Node) = [] of Node

    def render(
      document : Markd::Node,
      separator : String,
      highlight : Highlight,
    ) : Node
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
            in Markd::Node::Type::Document      then Node.new(Compiler::Builtin::Fragment)
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
                if highlight != Highlight::None
                  if (highlight == Highlight::MintOnly && language == "mint") ||
                     highlight == Highlight::All
                    ast =
                      Parser.parse_any(node.text.strip, "source.mint")

                    unless ast.nodes.empty?
                      SemanticTokenizer
                        .tokenize_with_lines(ast)
                        .map do |parts|
                          items =
                            parts.map do |part|
                              case part
                              in String
                                part
                              in Tuple(SemanticTokenizer::TokenType, String)
                                Node.new("span",
                                  attributes: {"class" => part[0].to_s.underscore},
                                  children: [part[1]] of Node | String)
                              end
                            end

                          Node.new("span",
                            attributes: {"class" => "line"},
                            children: items).as(Node | String)
                        end
                    end
                  end || begin
                    node.text.strip.split("\n").map do |part|
                      Node.new("span",
                        attributes: {"class" => "line"},
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
              stack.last?.try(&.children.concat(replace(item, separator)))
            end
          when Node
            stack.last?.try(&.children.concat(replace(item, separator)))
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

    def replace(item : String, separator : String) : Array(Node | String)
      if separator.size > 0 && item.includes?(separator)
        item
          .split(separator)
          .intersperse(separator)
          .map { |part| part.as(Node | String) }
      else
        [item] of Node | String
      end
    end

    def replace(node : Node, separator : String) : Array(Node | String)
      node.children =
        node.children.flat_map do |item|
          replace(item, separator)
        end

      [node] of Node | String
    end
  end
end
