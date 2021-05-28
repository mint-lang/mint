module Mint
  class Ast
    class Node
      # Line and column number pair.
      alias Position = {Int32, Int32}

      struct Location
        include JSON::Serializable

        # Relative file path of the `Node`,
        # this `Location` belongs to.
        getter filename : String

        # Starting line and column number of the `Node`,
        # this `Location` belongs to.
        getter start : Position

        # Ending line and column number of the `Node`,
        # this `Location` belongs to.
        getter end : Position

        def initialize(@filename, @start, @end)
        end

        def contains?(line : Int)
          start[0] <= line <= end[0]
        end

        def contains?(line : Int, column : Int)
          (start[0] <= line <= end[0]) &&
            (start[1] <= column <= end[1])
        end
      end

      getter input, from, to

      def initialize(@input : Data,
                     @from : Int32,
                     @to : Int32)
      end

      def to_tuple
        {input: input, from: from, to: to}
      end

      def owns?(node)
        false
      end

      def static?
        false
      end

      def static_value
        ""
      end

      def source
        input.input[from, to - from]
      end

      def new_line?
        source.strip.includes?('\n')
      end

      protected def compute_position(lines, needle) : Position
        line_start_pos, line = begin
          left, right = 0, lines.size - 1
          index = pos = 0
          found = false
          while left <= right
            middle = left + ((right - left) // 2)
            case pos = lines[middle]
            when .< needle
              left = middle + 1
            when .> needle
              right = middle - 1
            else
              index = middle
              found = true
              break
            end
          end

          unless found
            index = left - 1
            pos = lines[index]
          end

          {pos, index + 1}
        end

        column = needle - line_start_pos
        {line, column}
      end

      getter location : Location do
        # TODO: avoid creating this array for every (initial) call to `Node#location`
        lines = [0]
        @input.input.each_char_with_index do |ch, i|
          lines << i + 1 if ch == '\n'
        end

        Location.new(
          filename: @input.file,
          start: compute_position(lines, from),
          end: compute_position(lines, to),
        )
      end
    end
  end
end
