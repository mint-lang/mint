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

    def bold(contents)
      case contents
      when String
        @elements << {kind: "BOLD", contents: contents}
      end
    end

    def code(contents)
      case contents
      when String
        @elements << {kind: "CODE", contents: contents}
      end
    end

    def text(contents)
      case contents
      when String
        @elements << {kind: "TEXT", contents: contents}
      end
    end

    def title(contents : String)
      case contents
      when String
        @elements << {kind: "TITLE", contents: contents}
      end
    end

    def snippet(node)
      case node
      when Ast::Node
        @elements << {kind: "NODE", contents: node}
      end
    end
  end

  alias Element = NamedTuple(kind: String, contents: String | Array(Element) | Ast::Node)

  @data : Hash(String, String | Ast::Node)

  def initialize(@data)
  end

  macro method_missing(call)
    @data[{{call.name.id.stringify}}]?
  end

  def get(key)
    @data[key]?
  end

  def to_html
    contents = to_html build

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
          when "CODE"
            "<code>#{contents}</code>"
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
    to_terminal(build).to_s
  end

  def to_terminal(node)
    case node
    when String
      node
    when Ast::Node
      Snippet.render_terminal(node) + "\n\n"
    when Element
      to_terminal([node])
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
          when "CODE"
            "\"#{contents}\"".colorize(:light_yellow).mode(:bold)
          when "BLOCK"
            "#{contents}\n\n"
          when "TITLE"
            divider = "-" * (100 - contents.size - 4)
            "-- #{contents.upcase} #{divider}\n\n".colorize(:light_cyan).mode(:dim)
          when "NODE"
            contents
          end
        end
      end.compact.join("")
    end
  end
end

MESSAGES = {} of String => Message.class

macro message(name, &block)
	class Messages
		class {{name}} < Message
			def build
				Builder.new.build do
					{{block.body}}
				end
			end
		end

    MESSAGES["{{name}}"] = {{name}}
	end
end
