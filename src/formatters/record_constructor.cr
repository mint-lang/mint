module Mint
  class Formatter
    def format(node : Ast::RecordConstructor)
      arguments =
        unless node.arguments.empty?
          if node.new_line?
            "(\n#{indent(format(node.arguments, ",\n"))})"
          else
            "(#{format(node.arguments, ", ")})"
          end
        end

      "#{node.name}#{arguments}"
    end
  end
end
