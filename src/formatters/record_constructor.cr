module Mint
  class Formatter
    def format(node : Ast::RecordConstructor)
      arguments =
        unless node.arguments.empty?
          "(#{format(node.arguments, ", ")})"
        end

      "#{node.name}#{arguments}"
    end
  end
end
