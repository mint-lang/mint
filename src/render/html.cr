module Mint
  module Render
    class Html
      getter io : IO

      delegate escape, to: self.class

      def self.escape(code)
        HTML.escape(code)
      end

      def initialize(@io = IO::Memory.new, @width = 80)
      end

      def header(content)
        print "<h1>#{escape(content)}</h1>"
      end

      def block
        print "<p>"
        with self yield
        print "</p>"
      end

      def divider
        print "<hr>"
      end

      def type_list(data)
        items =
          data.join do |item|
            "<li><code>#{escape(item.to_pretty)}</code></li>"
          end

        print "<ul>#{items}</ul>"
      end

      def list(data)
        items =
          data.join do |item|
            "<li><b>#{escape(item)}</b></li>"
          end

        print "<ul>#{items}</ul>"
      end

      def print(content)
        io.print content
      end

      def snippet(node)
        print HtmlSnippet.render(node)
      end

      def title(content)
        print "<h2>#{escape(content)}</h2>"
      end

      def code(content)
        actual_content =
          case content
          when " ", ""
            "a space"
          when "\n"
            "a new line"
          when "\0"
            "end of file"
          else
            content
          end

        print "<code>#{escape(actual_content)}</code> "
      end

      def pre(content : String)
        print "<pre>#{escape(content)}</pre>"
      end

      def type(content)
        pre content.to_pretty
      end

      def bold(content)
        print "<b>#{escape(content + " ")}</b>"
      end

      def text(content)
        print escape(content + " ")
      end

      def render
        with self yield
        puts io
      end
    end
  end
end
