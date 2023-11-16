require "uri"

module Mint
  # This is a Virtual DOM renderer for markdown using Markd shard.
  #
  # The AST for the markdown is a tree where each node refers to the parent
  # node, next sibling and previous sibling.
  #
  # We walk the nodes and create virtual dom nodes using the `_h` function.
  # The `tag_end(node)` function closes a call with or without a comma `,`
  # depending if the node has a next sibling.
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
        tag_end(node)
      end
    end

    def paragraph(node, entering)
      if (grand_parent = node.parent?.try &.parent?) && grand_parent.type.list?
        return if grand_parent.data["tight"]
      end

      if entering
        tag("p")
      else
        tag_end(node)
      end
    end

    def code(node, entering)
      tag("code")
      text(node, entering)
      tag_end(node)
    end

    def code_block(node, entering)
      languages = node.fence_language.try(&.split)

      language =
        languages.try(&.first?).try(&.strip.presence)

      code_attributes =
        {} of String => String

      code_attributes["class"] =
        "language-#{language}" if language

      tag("pre")
      tag("code", code_attributes)

      if language == "mint"
        parser = Parser.new(node.text, "source.mint")
        parser.parse_any

        parts =
          SemanticTokenizer.tokenize(parser.ast)

        parts.each_with_index do |item, index|
          case item
          in String
            @io << '`' << item.gsub('`', "\\`") << '`'
          in Tuple(SemanticTokenizer::TokenType, String)
            tag("span", {"className" => item[0].to_s.underscore})
            @io << '`' << item[1].gsub('`', "\\`") << '`'
            tag_end
          end

          @io << ','
        end
      else
        @io << '`' << node.text.gsub('`', "\\`").strip << '`'
      end

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
      if entering
        tag_name =
          node.data["type"] == "bullet" ? "ul" : "ol"

        attributes = {} of String => String

        if start = node.data["start"].as(Int32)
          attributes["start"] = start.to_s unless start == 1
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
            "href" => node.data["destination"].as(String),
          }

        if title = node.data["title"].as(String).presence
          attributes["title"] = title
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
            "src" => node.data["destination"].as(String),
            "alt" => node.first_child.text,
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
      @io << ',' if node.next?
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
      @io << ',' if node.next?
    end

    {% begin %}
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
        {% for v in %i[
                      document heading list item code_block code
                      paragraph emphasis strong link block_quote image
                      soft_break line_break thematic_break
                    ] %}
        when .{{ v }}?
          {{ v.id }}(node, entering)
        {% end %}
        else
          text(node, entering)
        end
      end

      @io.to_s
    end
    {% end %}

    private def tag(name, attributes = nil)
      @io << "_h('" << name << "',"

      # Convert attributes to the JavaScript version.
      @io << '{'
      attributes.try &.join(@io, ',') do |(key, value), io2|
        io2 << key
        io2 << ':'
        value.inspect(io2)
      end
      @io << '}'

      @io << ",["
    end

    private def tag_end(node = nil)
      @io << "])"
      @io << ',' if node.try(&.next?)
    end
  end
end
