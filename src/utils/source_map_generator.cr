module Mint
  # This class is responsible for generating a source map.
  class SourceMapGenerator
    alias Mapping = Tuple(Ast::Node?, Tuple(Int32, Int32), String?)

    # The line mappings.
    getter mappings = {} of Int32 => Array(Mapping)

    # The actual content of the sources.
    getter sources_content = [] of String

    # The source names for the mappings.
    getter source_names = [] of String

    # The filenames of the sources.
    getter sources = [] of String

    # The generate JavaScript file.
    getter generated : String

    def initialize(unsorted : Deque(Mapping), @generated)
      # We sort the mappings into lines.
      unsorted.each do |item|
        (mappings[item[1][0]] ||= [] of Mapping) << item
      end
    end

    def get_source_index(file)
      sources.index(file.path) || begin
        sources_content << file.contents
        sources << file.path
        sources.size - 1
      end
    end

    def get_source_name_index(value)
      source_names.index(value) || begin
        source_names << value
        source_names.size - 1
      end
    end

    def generate : String
      last_name_index = 0
      last_column = 0
      last_index = 0
      last_line = 0

      generated_mappings =
        (0..generated.lines.size).map do |line_index|
          next "" unless items = mappings[line_index]?

          items.reduce({[] of String, 0}) do |(memo, last), item|
            column =
              item[1][1]

            segment =
              VLQ.encode(column - last)

            if node = item[0]
              source_line =
                node.from.line - 1

              source_column =
                node.from.column

              source_index =
                get_source_index(node.file)

              # The order is significant.
              segment += VLQ.encode(source_index - last_index)
              segment += VLQ.encode(source_line - last_line)
              segment += VLQ.encode(source_column - last_column)

              if name = item[2]
                source_name_index =
                  get_source_name_index(name)

                segment += VLQ.encode(source_name_index - last_name_index)
                last_name_index = source_name_index
              end

              last_column = source_column
              last_index = source_index
              last_line = source_line
            end

            memo << segment
            {memo, column}
          end.first.join(",")
        end.join(";")

      {
        mappings:       generated_mappings,
        sourcesContent: sources_content,
        names:          source_names,
        sources:        sources,
        version:        3,
      }.to_json
    end
  end
end
