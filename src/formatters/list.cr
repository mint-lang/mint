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

      # If this is the first node
      # save references
      if memo.empty?
        last = node
        last_formatted = formatted
      else
        # Check if space the nodes are separated by new lines
        space_separated =
          last && ast.space_separated?(last, node)

        # Decide the separator the separator
        separator =
          last_formatted.includes?("\n") ||
            formatted.includes?("\n") ||
            space_separated ? "\n\n" : "\n"

        # Save references
        last = node
        last_formatted = formatted

        # Return memo
        memo + separator + formatted
      end
    end
  end
end
