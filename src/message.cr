module Mint
  class Message
    class BlockBuilder
      getter block

      @block = Block.new

      def text(value)
        case value
        when String
          @block << Text.new(value: value)
        end
      end

      def code(value)
        @block << Code.new(value: value.to_s)
      end

      def bold(value)
        @block << Bold.new(value: value.to_s)
      end
    end

    class Builder
      getter elements

      @elements = [] of Element

      def self.build
        builder = new
        with builder yield
        builder.elements
      end

      def snippet(value, message = "Here is the relevant code snippet:")
        case value
        when Tuple(Ast::Node, Int32)
          snippet value[0], message
        when TypeChecker::Checkable
          type_with_text value, message
        when Ast::Node
          block { text message } if message
          @elements << Snippet.new(value: value)
        end
      end

      def type(value)
        case value
        when TypeChecker::Checkable
          @elements << Type.new(value: value)
        end
      end

      def pre(value)
        case value
        when String
          @elements << Pre.new(value: value)
        end
      end

      def list(value, message)
        case value
        when Array(String)
          unless value.empty?
            block do
              text message
            end
            @elements << StringList.new(value: value)
          end
        end
      end

      def list(value)
        case value
        when Array(String)
          unless value.empty?
            @elements << StringList.new(value: value)
          end
        end
      end

      def type_list(value)
        case value
        when Array(TypeChecker::Checkable)
          @elements << TypeList.new(value: value)
        end
      end

      def title(value)
        @elements << Title.new(value: value)
      end

      def block
        builder = BlockBuilder.new
        with builder yield
        @elements << builder.block
      end

      # Pre defined blocks
      def type_with_text(item, text)
        block do
          text text
        end

        type item
      end

      def was_expecting_type(expected, got)
        type_with_text expected, "I was expecting:"
        type_with_text got, "Instead it is:"
      end

      def was_looking_for(what, got, code = nil)
        block do
          text "I was looking for the"
          bold what

          code code if code

          text "but found"
          code got
          text "instead."
        end
      end

      def closing_bracket(expression, got)
        block do
          text "The"
          text "body of a"
          bold expression
          text "must end with"
          bold "a closing bracket."
        end

        was_looking_for "bracket", got, "}"
      end

      def opening_bracket(expression, got)
        block do
          text "The"
          text "body of a"
          bold expression
          text "must start with"
          bold "an opening bracket."
        end

        was_looking_for "bracket", got, "{"
      end
    end

    record TypeList, value : Array(TypeChecker::Checkable)
    record StringList, value : Array(String)
    record Type, value : TypeChecker::Checkable
    record Snippet, value : Ast::Node
    record Title, value : String
    record Code, value : String
    record Bold, value : String
    record Text, value : String
    record Pre, value : String

    alias Block = Array(Code | Bold | Text)
    alias Element = Title | Snippet | Block | Type | Pre | TypeList | StringList

    def initialize(@data = {} of String => String |
                                           Ast::Node |
                                           TypeChecker::Checkable |
                                           Array(TypeChecker::Checkable) |
                                           Array(String) |
                                           Tuple(Ast::Node, Int32))
    end

    macro method_missing(call)
      @data[{{call.name.id.stringify}}]
    end

    def to_html
      contents =
        render Render::Html.new

      <<-HTML
      <style>
        body {
          background: #960c0c;
          padding: 40px 0;
          color: #222;
        }

        article {
          box-shadow: 0 0 20px rgba(0,0,0,.1);
          font-family: sans-serif;
          background: #F6f6f6;
          border-radius: 4px;
          max-width: 1040px;
          margin: 0 auto;
          padding: 20px;
        }

        h2 {
          background: repeating-linear-gradient(
                      -45deg,
                      #f92323,
                      #f92323 10px,
                      #ff3d3d 10px,
                      #ff3d3d 30px);

          text-shadow: 0 0 10px rgba(158, 0, 0, 0.4);
          border-radius: 3px 3px 0 0;
          text-transform: uppercase;
          padding: 20px;
          color: #FFF;

          margin: -20px;
          margin-bottom: 20px;
        }

        .grid {
          border: 1px solid #DDD;
          background: #FFF;
          display: flex;
        }

        li {
          line-height: 34px
        }

        .line-numbers {
          border-right: 1px solid #DDD;
          margin-right: 10px;
          padding: 5px 0;
        }

        .line-number {
          text-align: right;
          line-height: 28px;
          padding: 0 10px;
          height: 24px;
        }

        .snippet pre {
          line-height: 24px;
          font-size: 14px;
          padding: 5px 0;
          overflow: auto;
          margin-top: 0;
          flex: 1;
        }

        code {
          background: #FFF;
          border: 1px solid rgba(0, 0, 0, 0.1);
          padding: 2px 7px;
          font-weight: bold;
          font-size: 16px;
          color: #333;
        }

        .snippet .file {
          border: 1px solid #DDD;
          background: #FCFCFC;
          font-weight: bold;
          padding: 7px 10px;
          border-bottom: 0;
          font-size: 14px;
          color: #333;
        }

        p {
          line-height: 26px;
        }

        p:first-child {
          margin-top: 0;
        }

        highlighted {
          display: inline-block;
          background: #ffebeb;
          padding: 0px 5px;
        }

        highlighted:empty {
          display: none;
        }

        @media only screen and (max-width: 600px)  {
          body {
            padding: 5px;
          }
        }
      </style>
      <article>
        #{contents}
      </article>
      HTML
    end

    def to_terminal(width)
      render Render::Terminal.new(width: width)
    end

    def build
      [] of Element
    end

    def render(renderer)
      build.each do |element|
        case element
        when TypeList
          renderer.type_list element.value
        when StringList
          renderer.list element.value
        when Pre
          renderer.pre element.value
        when Type
          renderer.type element.value
        when Title
          renderer.title element.value
        when Snippet
          renderer.snippet element.value
        when Block
          renderer.block do
            element.each do |item|
              case item
              when Text
                text item.value
              when Bold
                bold item.value
              when Code
                code item.value
              end
            end
          end
        end
      end

      renderer.io
    end
  end
end
