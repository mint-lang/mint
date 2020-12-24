require "json"

module Mint
  # Source Map rev. 3
  # https://docs.google.com/document/d/1U1RGAehQwRypUTovF1KRlpiOFze0b-_2gc6fAH0KY0k
  class SourceMap
    struct Mapping
      def initialize(@source_file_index : Int32,
                     @src_line : Int32,
                     @src_col : Int32,
                     @dst_line : Int32,
                     @dst_col : Int32,
                     @source_symbol_index : Int32?)
      end
    end

    class SourceFile
      def initialize(@file : Ast::Data, @index : Int32)
        @lines = [0] of Int32
        @file.input.each_char_with_index do |ch, i|
          if ch == '\n'
            @lines.push i + 1
          end
        end
      end

      def path
        @file.file
      end

      def content
        @file.input
      end

      def get_line_column_position(file_position : Int32)
        left = 0
        right = @lines.size - 1
        line_start_pos, line = begin
          index = 0
          found = false
          pos = 0
          while left <= right
            middle = left + ((right - left) / 2).to_i
            pos = @lines[middle]
            if pos < file_position
              left = middle + 1
            elsif pos > file_position
              right = middle - 1
            else
              index = middle
              found = true
              break
            end
          end

          if !found
            index = left - 1
            pos = @lines[index]
          end

          {pos, index}
        end

        column = file_position - line_start_pos
        {line, column}
      end
    end

    def initialize
      @sources = {} of String => SourceFile
      @sources_idx = [] of String
      @source_symbols = [] of String
      @source_symbols_to_idx = {} of String => Int32
      @mappings = {} of Int32 => Array(Mapping)
      @max_output_line = 0
    end

    def add_mapping(src_file : Ast::Data,
                    src_from : Int32,
                    dst_from_line : Int32,
                    dst_from_col : Int32,
                    src_symbol : String? = nil) : Nil
      file = @sources[src_file.file]? ||
             begin
               index = @sources_idx.size
               path = src_file.file
               @sources_idx.push path
               @sources[path] = SourceFile.new(src_file, index)
             end

      symbol_index = src_symbol.try do |symbol|
        @source_symbols_to_idx[symbol]? ||
          begin
            index = @source_symbols.size
            @source_symbols.push symbol
            @source_symbols_to_idx[symbol] = index
            index
          end
      end

      src_from_line, src_from_col = file.get_line_column_position src_from

      mapping = Mapping.new(file.@index, src_from_line, src_from_col, dst_from_line, dst_from_col, symbol_index)
      line_mappings = @mappings[dst_from_line]? || (@mappings[dst_from_line] = [] of Mapping)
      line_mappings.push mapping
      @max_output_line = Math.max(dst_from_line, @max_output_line)
    end

    def build_json(output_filename : String? = nil)
      JSON.build do |j|
        j.object do
          j.field "version", 3
          output_filename.try { |f| j.field "file", f }

          j.field "sources" do
            j.array do
              @sources_idx.each do |path|
                source = path
                j.string source
              end
            end
          end

          j.field "sourcesContent" do
            j.array do
              @sources_idx.each do |path|
                content = @sources[path].content
                j.string content
              end
            end
          end

          j.field "names" do
            j.array do
              @source_symbols.each do |s|
                j.string s
              end
            end
          end

          j.field "mappings" do
            mappings = String.build do |str|
              is_first_input = true
              last_source_file_index = -1
              last_src_line = -1
              last_src_col = -1
              last_source_symbol_index : Int32? = nil

              (0..@max_output_line).each do |line_index|
                line_mappings = @mappings[line_index]?

                if line_mappings
                  is_first_in_line = true
                  last_dst_col = -1

                  line_mappings.each_with_index do |mapping, mapping_index|
                    if is_first_in_line
                      dst_col = mapping.@dst_col
                      is_first_in_line = false
                    else
                      dst_col = mapping.@dst_col - last_dst_col
                    end
                    last_dst_col = mapping.@dst_col

                    source_file_index = mapping.@source_file_index
                    src_line = mapping.@src_line
                    src_col = mapping.@src_col
                    if is_first_input
                      is_first_input = false
                    else
                      source_file_index -= last_source_file_index
                      src_line -= last_src_line
                      src_col -= last_src_col
                    end
                    last_source_file_index = mapping.@source_file_index
                    last_src_line = mapping.@src_line
                    last_src_col = mapping.@src_col

                    source_symbol_index = mapping.@source_symbol_index
                    if source_symbol_index
                      if last_source_symbol_index
                        source_symbol_index -= last_source_symbol_index
                      end
                      last_source_symbol_index = mapping.@source_symbol_index
                    end

                    str << VLQ.encode(dst_col)
                    str << VLQ.encode(source_file_index)
                    str << VLQ.encode(src_line)
                    str << VLQ.encode(src_col)
                    str << VLQ.encode(source_symbol_index) if source_symbol_index
                    str << ',' if mapping_index < line_mappings.size - 1
                  end
                end

                str << ';' if line_index != @max_output_line
              end
            end

            j.string mappings
          end
        end
      end
    end
  end
end
