require "uri"

module Mint
  # This is a Virtual DOM renderer for markdown using Markd shard.
  #
  # The AST for the markdown is a tree where each node refers to the parent
  # node, next sibling and previous sibling.
  #
  # We walk the nodes and create virtual dom nodes using the `_h` function.
  # The `tag_end(node)` function closes a call with or without a comma `,`
  # depening if the node has a next sibling.
  class VDOMRenderer
    HEADINGS = %w(h1 h2 h3 h4 h5 h6)

    # Skip next is used to skip rendering of the next node.
    property? skip_next = false

    # Io contains the end result.
    getter io = String::Builder.new

    def document(node, entering)
      if entering
        @io << "_h(React.Fragment,{},["
      else
        tag_end
      end
    end

    def heading(node, entering)
      if entering
        tag_name =
          HEADINGS[node.data["level"].as(Int32) - 1]

        tag(tag_name)
      else
        tag_end node
      end
    end

    def paragraph(node, entering)
      if (grand_parant = node.parent?.try &.parent?) && grand_parant.type.list?
        return if grand_parant.data["tight"]
      end

      if entering
        tag("p")
      else
        tag_end node
      end
    end

    def code(node, entering)
      tag("code")
      text(node, entering)
      tag_end node
    end

    def code_block(node, entering)
      languages =
        node.fence_language.split if node.fence_language

      code_attributes =
        {} of String => String

      pre_attributes =
        {} of String => String

      language =
        languages.try(&.first?).try(&.strip.presence)

      code_attributes["class"] =
        %("language-#{language}") if language

      tag("pre", pre_attributes)
      tag("code", code_attributes)
      @io << '`' << node.text.gsub('`', "\\`").strip << '`'
      tag_end
      tag_end(node)
    end

    def thematic_break(node, entering)
      tag("hr")
      tag_end(node)
    end

    def block_quote(node, entering)
      if entering
        tag("blockquote")
      else
        tag_end(node)
      end
    end

    def list(node, entering)
      tag_name =
        node.data["type"] == "bullet" ? "ul" : "ol"

      if entering
        attributes = {} of String => String

        if (start = node.data["start"].as(Int32)) && start != 1
          attributes["start"] = %("#{start}")
        end

        tag(tag_name, attributes)
      else
        tag_end(node)
      end
    end

    def item(node, entering)
      if entering
        tag("li")
      else
        tag_end(node)
      end
    end

    def link(node, entering)
      if entering
        attributes =
          {
            "href" => %("#{node.data["destination"].as(String)}"),
          }

        if (title = node.data["title"].as(String)) && !title.empty?
          attributes["title"] = %("#{title}")
        end

        tag("a", attributes)
      else
        tag_end(node)
      end
    end

    def image(node, entering)
      if entering
        attributes =
          {
            "src" => %("#{node.data["destination"].as(String)}"),
            "alt" => %("#{node.first_child.text}"),
          }

        tag("img", attributes)
        @skip_next = true # Skips the next tag which is the alt...
      else
        tag_end(node)
      end
    end

    def emphasis(node, entering)
      if entering
        tag("em")
      else
        tag_end(node)
      end
    end

    def soft_break(node, entering)
      @io << "`\n`"

      if node.next?
        @io << ','
      end
    end

    def line_break(node, entering)
      tag("br")
      tag_end(node)
    end

    def strong(node, entering)
      if entering
        tag("strong")
      else
        tag_end(node)
      end
    end

    def text(node, entering)
      @io << '`' << node.text.gsub('`', "\\`") << '`'

      if node.next?
        @io << ','
      end
    end

    def render(document : Markd::Node)
      walker = document.walker
      while event = walker.next
        if @skip_next
          @skip_next = false
          next
        end

        node, entering = event

        # HTMLBlock and HTMLInline is not supported and converted to text...

        case node.type
        when Markd::Node::Type::Document
          document(node, entering)
        when Markd::Node::Type::Heading
          heading(node, entering)
        when Markd::Node::Type::List
          list(node, entering)
        when Markd::Node::Type::Item
          item(node, entering)
        when Markd::Node::Type::BlockQuote
          block_quote(node, entering)
        when Markd::Node::Type::ThematicBreak
          thematic_break(node, entering)
        when Markd::Node::Type::CodeBlock
          code_block(node, entering)
        when Markd::Node::Type::Code
          code(node, entering)
        when Markd::Node::Type::Paragraph
          paragraph(node, entering)
        when Markd::Node::Type::Emphasis
          emphasis(node, entering)
        when Markd::Node::Type::SoftBreak
          soft_break(node, entering)
        when Markd::Node::Type::LineBreak
          line_break(node, entering)
        when Markd::Node::Type::Strong
          strong(node, entering)
        when Markd::Node::Type::Link
          link(node, entering)
        when Markd::Node::Type::Image
          image(node, entering)
        else
          text(node, entering)
        end
      end

      @io.to_s
    end

    private def tag(name, attributes = {} of String => String)
      # Convert attibutes to the JavaScript version.
      js_attributes =
        if attributes.empty?
          "{}"
        else
          "{" + attributes.map { |key, value| "#{key}:#{value}" }.join(",") + "}"
        end

      @io << "_h('" << name << "'," << js_attributes << ",["
    end

    private def tag_end(node = nil)
      if node.try(&.next?)
        @io << "]),"
      else
        @io << "])"
      end
    end
  end
end
