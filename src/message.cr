class Message
  class BlockBuilder
    getter block

    @block = Block.new

    def text(value)
      @block << Text.new(value: value)
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
      when TypeChecker::Type
        type_with_text value, message
      when Ast::Node
        block { text message } if message
        @elements << Snippet.new(value: value)
      end
    end

    def type(value)
      case value
      when TypeChecker::Type
        @elements << Type.new(value: value)
      end
    end

    def pre(value)
      case value
      when String
        @elements << Pre.new(value: value)
      end
    end

    def type_list(value)
      case value
      when Array(TypeChecker::Type)
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

  record TypeList, value : Array(TypeChecker::Type)
  record Type, value : TypeChecker::Type
  record Snippet, value : Ast::Node
  record Title, value : String
  record Code, value : String
  record Bold, value : String
  record Text, value : String
  record Pre, value : String

  alias Block = Array(Code | Bold | Text)
  alias Element = Title | Snippet | Block | Type | Pre | TypeList

  def initialize(@data = {} of String => String | Ast::Node | TypeChecker::Type | Array(TypeChecker::Type))
  end

  macro method_missing(call)
    @data[{{call.name.id.stringify}}]?
  end

  def to_html
    contents =
      render Render::Html.new

    <<-HTML
    <style>
      body {
        background: #F6f6f6;
        color: #222;
      }
      article {
        font-family: sans-serif;
        max-width: 1040px;
        margin: 0 auto;
        padding-top: 20px;
      }
      h2 {
        border-bottom: 2px solid #b222223d;
        text-transform: uppercase;
        padding-bottom: 10px;
        color: firebrick;
      }
      pre line {
        display: block;
        line-height: 20px;
      }
      pre line::before {
        content: attr(line);
        border-right: 1px solid rgba(0,0,0,0.1);
        text-align: right;
        padding: 0 10px;
        padding-left: 5px;
        margin-right: 10px;
        line-height: inherit;
        display: inline-block;
        width: 16px;
      }
      pre {
        border: 1px solid #DDD;
        background: #FFF;
        padding: 5px;
        margin-top: 0;
      }
      code {
        background: #FFF;
        border: 1px solid rgba(0,0,0,0.1);
        padding: 2px 7px;
        font-weight: bold;
        font-size: 16px;
        color: #333;
      }
      .file {
        border: 1px solid #DDD;
        border-bottom: 0;
        padding: 7px 10px;
        font-size: 14px;
        text-transform: uppercase;
        font-weight: bold;
        background: #FCFCFC;
        color: #333;
      }
      p {
        line-height: 26px;
      }
      highlighted {
        display: inline-block;
        background: #ffebeb;
        padding: 0px 5px;
      }
      highlighted:empty {
        display: none;
      }
    </style>
    <article>
      #{contents}
    <article>
    HTML
  end

  def to_terminal(width)
    render Render::Terminal.new(width: width)
  end

  def build
    Builder.build do
      block do
        text "The error"
        bold error
        text "does not have a message yet."
      end
      snippet node
    end
  end

  def render(renderer)
    build.each do |element|
      case element
      when TypeList
        renderer.type_list element.value
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

MESSAGES = {} of String => Message.class

macro message(name, &block)
	class Messages
		class {{name}} < Message
			def build
        Builder.build do
          {{block.body}}
        end
			end
		end

    MESSAGES["{{name}}"] = {{name}}
	end
end
