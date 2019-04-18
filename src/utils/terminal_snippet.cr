module Mint
  module TerminalSnippet
    record Line, contents : String, index : Int32, offset : Int32 do
      def contains?(position)
        position >= offset && position <= (offset + size)
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
          [from - offset, 0].max

        diff_to =
          [[to - offset, contents.size].min, 0].max

        left =
          self[0, diff_from]

        center =
          self[diff_from, diff_to].colorize(:light_yellow).mode(:bright).to_s

        right =
          self[diff_to, contents.size]

        left + center + right
      end

      def [](from, to)
        contents[from, to - from]
      rescue IndexError | ArgumentError
        ""
      end
    end

    extend self

    def render(input : String, filename : String, from : Int32, to : Int32, padding = 4, width = 80)
      lines, _ =
        input.lines.reduce({[] of Line, 0}) do |memo, raw|
          items, index = memo

          offset =
            items.reduce(0) { |acc, item| acc + item.contents.size + 1 }

          line =
            Line.new(contents: raw, index: index, offset: offset)

          {items + [line], index + 1}
        end

      start_line =
        [0, (lines.find(&.contains?(from)).try(&.index) || 0) - padding].max

      end_line =
        [(lines.find(&.contains?(to)).try(&.index) || 0) + padding + 1, lines.size].min

      gutter_width =
        [(start_line + 1).to_s.size,
         (end_line + 1).to_s.size,
        ].max

      relevant_lines =
        lines[start_line, end_line - start_line]

      min_width =
        [
          relevant_lines.map(&.size).max + gutter_width + 5,
          width,
        ].max

      result =
        relevant_lines.map do |line|
          line_number =
            (line.index + 1).to_s.rjust(gutter_width)

          line_padding =
            " " * (min_width - gutter_width - 3 - line.size - 2)

          highlighted =
            line.contains?(from, to)

          gutter =
            if highlighted
              "│#{line_number}│".colorize(:light_yellow).mode(:bright)
            else
              "│#{line_number}│".colorize.mode(:dim)
            end

          divier =
            if highlighted
              "│".colorize(:light_yellow).mode(:bright)
            else
              "│".colorize.mode(:dim)
            end

          "#{gutter} #{line.highlight(from, to)} #{line_padding}#{divier}"
        end

      divider =
        ("─" * (min_width - filename.size - gutter_width - 5)).colorize.mode(:dim)

      gutter_divider =
        "─" * gutter_width

      footer_divider =
        "─" * (min_width - gutter_width - 3)

      footer =
        ("└#{gutter_divider}┴#{footer_divider}┘").colorize.mode(:dim)

      title =
        filename.colorize.mode(:bold)

      header_start =
        "┌#{gutter_divider}┬".colorize.mode(:dim)

      header_end =
        "┐".colorize.mode(:dim).to_s

      header =
        "#{header_start} #{title} #{divider}#{header_end}"

      result =
        result.join("\n")

      "#{header}\n#{result}\n#{footer}"
    end
  end
end
