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

    def title(value)
      @elements << Title.new(value: value)
    end

    def block
      builder = BlockBuilder.new
      with builder yield
      @elements << builder.block
    end
  end

  record Type, value : TypeChecker::Type
  record Snippet, value : Ast::Node
  record Title, value : String
  record Code, value : String
  record Bold, value : String
  record Text, value : String

  alias Block = Array(Code | Bold | Text)
  alias Element = Title | Snippet | Block | Type

  def initialize(@data = {} of String => String | Ast::Node | TypeChecker::Type)
  end

  macro method_missing(call)
    @data[{{call.name.id.stringify}}]?
  end

  def to_html
    render Render::Html.new
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
