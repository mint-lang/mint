module Mint
  class IndentedStringBuilder
    property indent_size : Int32 = 0

    def initialize
      @str_builder = String::Builder.new(16384)
      @last_input_had_endl = false
      @left_strip = false
      @line = 0
      @column = 0
    end

    def size
      @str_builder.bytesize
    end

    def get_position_for_next_input
      {line:   @last_input_had_endl ? @line + 1 : @line,
       column: @last_input_had_endl ? indent_size : (@str_builder.empty? ? indent_size : @column)}
    end

    def <<(str : String) : self
      if str.size == 0
        return self
      end

      if @last_input_had_endl
        @str_builder << '\n'
        @line += 1
        @column = 0
      end

      if indent_size > 0 && !@left_strip
        # let's not have lines filled with only spaces
        if (@last_input_had_endl || @str_builder.empty?) && !str.blank?
          @str_builder << " " * indent_size
          @column += indent_size
        end
      end

      # add indentation to all but last endline
      ch = ' '
      new_str = String.build do |s|
        last_index = str.size - 1

        i = 0
        while i <= last_index
          ch = str[i]
          next_ch = str[i + 1]?

          if ch != ' ' && ch != '\n'
            @left_strip = false
          end

          if i < last_index || ch != '\n'
            if !@left_strip || ch != ' '
              s << ch

              if ch == '\n'
                @line += 1
                @column = 0
              else
                @column += 1
              end
            end
          end

          if ch == '\n' && next_ch != '\n' && i < last_index && !@left_strip
            s << " " * indent_size
            @column += indent_size
          end

          i += 1
        end
      end
      @last_input_had_endl = ch == '\n'
      @str_builder << new_str

      self
    end

    def build
      if @last_input_had_endl
        @str_builder << '\n'
        @line += 1
        @column = 0
      end
      @str_builder.to_s
    end

    def strip_whitespace_around
      start_size = @str_builder.bytesize
      @left_strip = true
      yield
      strip_end_whitespace start_size
    end

    private def strip_end_whitespace(start_size)
      @last_input_had_endl = false

      recalculate_column = false
      i = @str_builder.bytesize
      while i > start_size
        ch = @str_builder.buffer[i - 1]

        if ch == ' '.ord
          @column -= 1
        elsif ch == '\n'.ord
          @line -= 1
          recalculate_column = true
        else
          break
        end

        i -= 1
      end

      diff = @str_builder.bytesize - i
      if diff > 0
        @str_builder.back diff

        if recalculate_column
          n = @str_builder.bytesize
          i = n - 1
          while i > 0
            ch = @str_builder.buffer[i]
            break if ch == '\n'
            i -= 1
          end

          @column = n - i + 1
        end
      end
    end
  end
end
