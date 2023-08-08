module Mint
  class Parser
    def destructuring : Ast::Node?
      array_destructuring ||
        tuple_destructuring ||
        type_destructuring ||
        expression
    end
  end
end
