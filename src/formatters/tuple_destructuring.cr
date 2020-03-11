module Mint
  class Formatter
    def format(node : Ast::TupleDestructuring)
      "{#{format(node.parameters, ", ")}}"
    end
  end
end
