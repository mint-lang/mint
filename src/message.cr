class Message
  class Builder
    @elements = [] of Element

    def build : Array(Element)
      with self yield
      @elements
    end

    def block
      old_elements = @elements
      @elements = [] of Element
      with self yield
      old_elements << {kind: "BLOCK", contents: @elements}
      @elements = old_elements
    end

    def bold(contents : Nil)
    end

    def bold(contents : String)
      @elements << {kind: "BOLD", contents: contents}
    end

    def text(contents : String)
      @elements << {kind: "TEXT", contents: contents}
    end

    def title(contents : String)
      @elements << {kind: "TITLE", contents: contents}
    end

    def snippet(node)
      case node
      when Ast::Node
        @elements << {kind: "NODE", contents: node}
      end
    end
  end

  alias Element = NamedTuple(kind: String, contents: String | Array(Element) | Ast::Node)

  @data : Hash(String, String)

  def initialize(@data)
  end

  def get(key)
    @data[key]?
  end

  def to_html
    to_html build
  end

  def to_html(node)
    case node
    when String
      Snippet.escape(node)
    when Ast::Node
      Snippet.render(node)
    when Element
      to_html([node])
    when Array(Element)
      node.map do |item|
        case item
        when Element
          contents = to_html(item[:contents])

          case item[:kind]
          when "TEXT"
            contents
          when "BOLD"
            "<b>#{contents}</b>"
          when "BLOCK"
            "<p>#{contents}</p>"
          when "TITLE"
            "<h2>#{contents}</h2>"
          when "NODE"
            contents
          end
        end
      end.compact.join("")
    end
  end

  def to_terminal
    to_terminal(build).to_s + ("=" * 100).colorize(:light_cyan).mode(:dim).to_s
  end

  def to_terminal(node)
    case node
    when String
      node
    when Ast::Node
      Snippet.render_terminal(node) + "\n\n"
    when Element
      to_html([node])
    when Array(Element)
      node.map do |item|
        case item
        when Element
          contents =
            to_terminal(item[:contents]).to_s

          case item[:kind]
          when "TEXT"
            contents
          when "BOLD"
            contents.colorize(:light_yellow).mode(:bold)
          when "BLOCK"
            "#{contents}\n\n"
          when "TITLE"
            divider = "=" * (100 - contents.size - 4)
            "== #{contents.upcase} #{divider}\n\n".colorize(:light_cyan).mode(:dim)
          when "NODE"
            contents
          end
        end
      end.compact.join("")
    end
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
  block do
    text "I was looking for the name of the field of the record but found "
    bold get("got")
    text " instead."
  end
end

puts Messages::AccessExpectedVariable.new({"got" => "???"}).to_terminal
