module Mint
  class Formatter
    # Formats a list of nodes while preserving
    # whitespace between them
    def list(nodes : Array(Ast::Node)) : String
      last_formatted = ""
      last = nil

      nodes
        .sort_by(&.from)
        .reduce("") do |memo, node|
          # Format the node
          formatted = format node

          next memo if formatted.empty?

          # If this is the first node
          # save references
          if memo.empty?
            last = node
            last_formatted = formatted
          else
            # Check if space the nodes are separated by new lines
            space_separated =
              last && ast.space_separated?(last, node)

            # Decide the separator
            separator =
              if last.is_a?(Ast::Comment) && node.is_a?(Ast::Comment)
                "\n\n"
              elsif !last.is_a?(Ast::Comment) && node.is_a?(Ast::Comment)
                "\n\n"
              elsif last.is_a?(Ast::Comment) && node.responds_to?(:comment) && node.comment
                "\n\n"
              elsif last.is_a?(Ast::Comment)
                "\n"
              elsif replace_skipped(last_formatted).includes?("\n") ||
                    replace_skipped(formatted).includes?("\n") ||
                    space_separated
                "\n\n"
              else
                "\n"
              end

            # Save references
            last = node
            last_formatted = formatted

            # Return memo
            memo + separator + formatted
          end
        end
    end
  end
end
