module Snippet
  extend self

  def escape(code)
    HTML.escape(code.gsub('\\', "\\\\").gsub('`', "\\`"))
  end

  def code_list(items)
    list items.map { |item| "<code>#{item}</code>" }
  end

  def list(items)
    lis = items.map { |item| "<li>#{item}</li>" }.join("")
    "<ul>#{lis}</ul>"
  end

  def render(node : Ast::Node)
    input =
      node.input.input

    start_line =
      input[0, node.from].count("\n\r")

    end_line =
      input[0, node.to].count("\n\r")

    start =
      Math.max(0, start_line - 3)

    last =
      Math.min(end_line + 4, input.lines.size)

    left =
      escape input[0, node.from]

    part =
      escape(input[node.from, node.to - node.from])

    center =
      if part.strip.empty?
        "<highlighted>&nbsp;</highlighted>"
      else
        part
          .lines
          .map do |line|
          line.gsub(/^(\s*)(.*)(\s*)$/) do |all, match|
            "#{match[1]}<highlighted>#{match[2]}</highlighted>#{match[3]}"
          end
        end.join("\n")
      end

    right =
      if node.to < input.size
        escape input[node.to, input.size - node.to]
      else
        ""
      end

    prepared =
      "#{left}#{center}#{right}"

    content =
      prepared.lines[start, last - start + 1]
              .map_with_index do |code, index|
        "<line line='#{index + start + 1}'>#{code}</line>"
      end.join("")

    "<div>
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
      <div class='file'>
        #{node.input.file}
      </div>
  		<pre>#{content}</pre>
  	</div>"
  end
end
