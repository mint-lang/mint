class Message
  class Builder
    @elements = [] of Element

    def build : Array(Element)
      with self yield
      @elements
    end

    def text
      @elements << {kind: "TEXT", contents: yield}
    end

    def text(contents : String)
      @elements << {kind: "TEXT", contents: contents}
    end

    def titles
      @elements << {kind: "TITLE", contents: yield}
    end

    def title(contents : String)
      @elements << {kind: "TITLE", contents: contents}
    end

    def snippet(node : Ast::Node)
      @elements << {kind: "NODE", contents: node}
    end
  end

  alias Element = NamedTuple(kind: String, contents: String | Array(Element) | Ast::Node)

  @data : Hash(String, String | Ast::Node)

  def initialize(@data)
  end

  macro method_missing(call)
  	value = @data[{{call.name.id.stringify}}]?
  	case value
  	when String
  		value
  	when Ast::Node
  		value
  	else
  		""
  	end
  end

  def to_html
    to_html build
  end

  def to_html(node)
    case node
    when String
      Snippet.escape(node)
    when Array(Element)
      node.map do |item|
        case item
        when Element
          contents = to_html(item[:contents])

          case item[:kind]
          when "TEXT"
            "<p>#{contents}</p>"
          when "TITLE"
            "<h2>#{contents}</h2>"
          end
        end
      end.compact.join("")
    end
  end

  def to_terminal
    to_terminal build
  end

  def to_terminal(node)
  end
end

macro message(name, &block)
	class Messages
		class {{name}} < Message
			def build
				Builder.new.build do
					{{block.body}}
				end
			end
		end
	end
end

message AccessExpectedVariable do
  title "Syntax Error"
  text "I was looking for the name of the field of the record but found #{got} instead."
end

p Messages::AccessExpectedVariable.new({} of String => String | Ast::Node).to_html
