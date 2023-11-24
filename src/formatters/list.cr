module Mint
  class Formatter
    def list(nodes : Array(Ast::Node), delimeter : String? = nil) : String
      list(nodes.zip(format(nodes)).to_a, delimeter)
    end

    # Formats a list of nodes while preserving
    # whitespace between them
    def list(nodes : Array(Tuple(Ast::Node, String)), delimeter : String? = nil) : String
      last_formatted = ""
      last = nil

      nodes
        .sort_by(&.first.from)
        .reduce("") do |memo, (node, formatted)|
          next memo if formatted.empty?

          # If this is the first node
          # save references
          if memo.empty?
            last = node
            last_formatted = formatted
          else
            # Check if space the nodes are separated by new lines
            space_separated =
              last && Ast.space_separated?(last, node)

            # Decide the separator
            separator =
              case
              when last.is_a?(Ast::Comment) && node.is_a?(Ast::Comment)
                if last.block? || node.block?
                  "\n\n"
                else
                  "\n"
                end
              when !last.is_a?(Ast::Comment) && node.is_a?(Ast::Comment)
                "\n\n"
              when last.is_a?(Ast::Comment) && node.responds_to?(:comment) && node.comment
                "\n\n"
              when last.is_a?(Ast::Comment)
                "\n"
              when space_separated
                "\n\n"
              when !node.is_a?(Ast::Field) && !last.is_a?(Ast::Field) &&
                (replace_skipped(last_formatted).includes?('\n') ||
                  replace_skipped(formatted).includes?('\n'))
                "\n\n"
              else
                "\n"
              end

            # Save references
            last = node
            last_formatted = formatted

            # Return memo
            "#{memo}#{delimeter}#{separator}#{formatted}"
          end
        end
    end
  end
end
