module Mint
  module Snippet
    extend self

    def escape(code, shouldEscape = true)
      return code unless shouldEscape
      HTML.escape(code.gsub('\\', "\\\\").gsub('`', "\\`"))
    end

    def code_list(items)
      list items.map { |item| "<code>#{item}</code>" }
    end

    def list(items)
      lis = items.map { |item| "<li>#{item}</li>" }.join("")
      "<ul>#{lis}</ul>"
    end

    def process(node : Ast::Node, shouldEscape = false)
      input =
        node.input.input

      start_line =
        input[0, node.from].count("\n\r")

      end_line =
        input[0, node.to].count("\n\r")

      start =
        Math.max(0, start_line - 4)

      last =
        Math.min(end_line + 4, input.lines.size)

      left =
        escape input[0, node.from], shouldEscape

      part =
        escape input[node.from, node.to - node.from], shouldEscape

      center =
        yield part

      right =
        if node.to < input.size
          escape input[node.to, input.size - node.to], shouldEscape
        else
          ""
        end

      {"#{left}#{center}#{right}", start, last}
    end

    def render_terminal(node : Ast::Node, width)
      TerminalSnippet.render(node.input.input, node.input.file, node.from, node.to, width: width)
    end

    def render(node : Ast::Node)
      prepared, start, last =
        process node, true do |part|
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
        end

      content =
        prepared.lines[start, last - start + 1]
                .map_with_index do |code, index|
          "<line line='#{index + start + 1}'>#{code}</line>"
        end.join("")

      "<div>
      <div class='file'>
        #{node.input.file}
      </div>
  		<pre>#{content}</pre>
  	</div>"
    end
  end
end
