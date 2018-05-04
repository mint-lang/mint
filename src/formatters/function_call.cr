module Mint
  class Formatter
    def format(node : Ast::FunctionCall) : String
      function =
        format node.function

      format function, node
    end
  end
end
