module Mint
  module HtmlSnippet
    delegate escape, to: Render::Html

    extend self

    def render(node : Ast::Node)
      input =
        node.input.input

      start_line =
        input[0, node.from].lines.size

      end_line =
        input[0, node.to].lines.size

      start =
        Math.max(0, start_line - 4)

      last =
        Math.min(end_line + 4, input.lines.size)

      left =
        escape input[0, node.from]

      part =
        escape input[node.from, node.to - node.from]

      center =
        if part.strip.empty?
          "<highlighted>&nbsp;</highlighted>"
        else
          part
            .lines
            .join('\n') do |line|
              line.gsub(/^(\s*)(.*)(\s*)$/) do |_, match|
                "#{match[1]}<highlighted>#{match[2]}</highlighted>#{match[3]}"
              end
            end
        end

      right =
        if node.to < input.size
          escape input[node.to, input.size - node.to]
        else
          ""
        end

      content =
        "#{left}#{center}#{right}".lines[start, last - start + 1]

      line_numbers =
        content.map_with_index do |_, index|
          "<div class='line-number'>#{index + start + 1}</div>"
        end.join('\n')

      <<-HTML
      <div class="snippet">
        <div class='file'>
          #{node.input.file}
        </div>
        <div class="grid">
          <div class="line-numbers">
              #{line_numbers}
          </div>
          <pre>#{content.join('\n')}</pre>
        </div>
      </div>
      HTML
    end
  end
end
