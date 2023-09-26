module Mint
  module TerminalSnippet
    record Line, contents : String, index : Int64, offset : Int64 do
      def contains?(position)
        position >= offset && position <= (offset + size)
      end

      def fully_contains?(from, to)
        contains?(from, to) && (to - from) < contents.size
      end

      def contains?(from, to)
        diff_from =
          from - offset

        diff_to =
          to - offset

        diff_to > 0 && diff_from < contents.size
      end

      def size
        contents.size
      end

      def highlight(from, to)
        diff_from =
          {from - offset, 0}.max

        diff_to =
          {[to - offset, contents.size].min, 0}.max

        left =
          self[0, diff_from]

        center =
          self[diff_from, diff_to].colorize.on(:white).fore(:red).to_s

        right =
          self[diff_to, contents.size]

        highlighted =
          left + center + right

        arrows =
          (" " * left.size) + ("⌃" * center.uncolorize.size)

        {highlighted, arrows}
      end

      def [](from, to)
        contents[from, to - from]
      rescue IndexError | ArgumentError
        ""
      end
    end

    extend self

    def render(input : String, filename : String, from : Int64, to : Int64, padding = 4, width = 80)
      # Transform each line into a record for further use.
      lines =
        input.lines.reduce({[] of Line, 0}) do |memo, raw|
          items, index = memo

          offset =
            items.reduce(0) { |acc, item| acc + item.contents.size + 1 }

          line =
            Line.new(contents: raw, index: index, offset: offset)

          {items + [line], index + 1}
        end[0]

      selected =
        lines.select(&.contains?(from, to))

      fully_highlighted =
        selected.size == lines.size

      # Get the first line which is the one we want to highlight minus the padding.
      start_line =
        {0, (lines.find(&.contains?(from)).try(&.index) || 0) - padding}.max

      # Get the last line which is the one we want to highlight plus the padding.
      end_line =
        {(lines.find(&.contains?(to)).try(&.index) || 0) + padding + 1, lines.size}.min

      # We need to calucluate the width of the gutter so we can pad later lon.
      gutter_width = {
        (start_line + 1).to_s.size,
        (end_line + 1).to_s.size,
      }.max

      relevant_lines =
        lines[start_line, end_line - start_line]

      result =
        relevant_lines.map do |line|
          line_number =
            (line.index + 1).to_s.rjust(gutter_width)

          highlighted =
            line.fully_contains?(from, to)

          gutter =
            if highlighted
              "#{line_number}│".colorize(:light_yellow).mode(:bright)
            else
              "#{line_number}│".colorize.mode(:dim)
            end

          if fully_highlighted
          elsif selected.size > 1 && selected.last == line
            max_size =
              selected.max_of(&.contents.size)

            whitespace =
              selected.min_of do |item|
                count = 0
                item.contents.each_char do |char|
                  break unless char.ascii_whitespace?
                  count += 1
                end || 0
                count
              end

            content_size =
              max_size - whitespace

            arrows =
              "#{" " * whitespace}#{"⌃"*content_size}"

            "#{gutter} #{line.contents}\n#{" " * gutter_width}│ #{arrows}"
          elsif selected.size > 1 && selected.first == line
            max_size =
              selected.max_of(&.contents.size)

            whitespace =
              selected.min_of do |item|
                count = 0
                item.contents.each_char do |char|
                  break unless char.ascii_whitespace?
                  count += 1
                end || 0
                count
              end

            content_size =
              max_size - whitespace

            arrows =
              "#{" " * whitespace}#{"⌄"*content_size}"

            "#{" " * gutter_width}│ #{arrows}\n#{gutter} #{line.contents}"
          elsif highlighted
            a, b =
              line.highlight(from, to)

            "#{gutter} #{a}\n#{" " * gutter_width}│ #{b}"
          elsif from == input.size && line.offset + line.contents.size == from
            "#{gutter} #{line.contents}\n#{" " * gutter_width}│ #{" " * line.contents.size}⌃⌃⌃⌃"
          end || "#{gutter} #{line.contents}"
        end

      line =
        input[0..from].lines.size

      column =
        input[0..from].lines.last.size

      title =
        "#{filename}:#{line}:#{column}"

      gutter_divider =
        " " * gutter_width

      header_start =
        "#{gutter_divider}┌ ".colorize.mode(:dim)

      title_colorized =
        title.colorize.mode(:bold)

      header =
        "#{header_start}#{title_colorized}"

      header_divider_width =
        [
          header.uncolorize.size - (gutter_width + 1),
          relevant_lines.max_of(&.size) + 1,
        ].max

      header_divider =
        "#{gutter_divider}├" + ("─" * header_divider_width)

      result =
        result.join('\n')

      "#{header}\n#{header_divider}\n#{result}"
    end
  end
end
