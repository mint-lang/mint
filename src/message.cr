module Mint
  class Message
    class BlockBuilder
      getter block = Block.new

      def text(value)
        case value
        when String
          @block << Text.new(value: value)
        else
          raise ArgumentError.new "Invalid value type: #{value.class}"
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
      getter elements = [] of Element

      def self.build
        builder = new
        with builder yield
        builder.elements
      end

      def snippet(value, message : String? = "Here is the relevant code snippet:")
        case value
        when Tuple(Ast::Node, Int32)
          snippet value[0], message
        when TypeChecker::Checkable
          type_with_text value, message.to_s
        when Ast::Node
          block { text message } if message
          @elements << Snippet.new(value: value)
        else
          raise ArgumentError.new "Invalid value type: #{value.class}"
        end
      end

      def type(value)
        case value
        when TypeChecker::Checkable
          @elements << Type.new(value: value)
        else
          raise ArgumentError.new "Invalid value type: #{value.class}"
        end
      end

      def pre(value)
        case value
        when String
          @elements << Pre.new(value: value)
        else
          raise ArgumentError.new "Invalid value type: #{value.class}"
        end
      end

      def list(value, message : String)
        case value
        when Array(String)
          unless value.empty?
            block do
              text message
            end
            @elements << StringList.new(value: value)
          end
        else
          raise ArgumentError.new "Invalid value type: #{value.class}"
        end
      end

      def list(value)
        case value
        when Array(String)
          unless value.empty?
            @elements << StringList.new(value: value)
          end
        else
          raise ArgumentError.new "Invalid value type: #{value.class}"
        end
      end

      def type_list(value)
        case value
        when Array(TypeChecker::Checkable)
          @elements << TypeList.new(value: value)
        else
          raise ArgumentError.new "Invalid value type: #{value.class}"
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
      def type_with_text(item, text : String)
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

    @data : Error::Locals

    def initialize(@data = Error::Locals.new)
    end

    macro method_missing(call)
      @data[{{ call.name.id.stringify }}]?
    end

    def to_html
      # ameba:disable Lint/UselessAssign
      contents =
        render Render::Html.new

      ECR.render("#{__DIR__}/message.ecr")
    end

    def to_terminal(width)
      render Render::Terminal.new(width: width)
    end

    def build
      Builder.build do
        snippet node
      end
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
