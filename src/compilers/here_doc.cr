module Mint
  class Compiler
    def _compile(node : Ast::HereDoc) : String
      # Compile the non interpolation parts and the
      # interpolation parts together into a string.
      value =
        node
          .value
          .join do |item|
            case item
            when Ast::Node
              "${#{compile(item)}}"
            when String
              item
                .gsub('`', "\\`")
                .gsub("${", "\\${")
            else
              ""
            end
          end
          .lchop('\n')
          .lchop('\r')
          .lchop("\n\r")
          .rstrip

      if node.modifier == '~'
        # We start from the maximum number for indent size
        indent_size =
          Int32::MAX

        # Interate over all the lines and:
        # - replace tabs with 2 spaces
        # - update the indent size if it's smaller than the previous
        lines =
          value

            .lines
            .map do |line|
              reader = Char::Reader.new(line)
              size = 0

              loop do
                case reader.current_char
                when '\t'
                  size += 2
                when ' '
                  size += 1
                else
                  break
                end

                reader.next_char
              end

              # For the indent size we ignore blank lines
              if size < indent_size && !line.blank?
                indent_size = size
              end

              (" " * size) + line[reader.pos..]
            end

        # Remove the least number of indentation and recreate the string.
        value =
          lines
            .map { |line| line[indent_size..] }
            .join("\n")
      end

      "`#{skip { value }}`"
    end
  end
end
