module Mint
  class Formatter
    def format(node : Ast::RecordConstructor)
      arguments =
        if node.arguments.any?
          "(#{format(node.arguments, ", ")})"
        end

      "#{node.name}#{arguments}"
    end
  end
end
