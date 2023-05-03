module Mint
  class Parser
    def destructuring : Ast::Node?
      array_destructuring ||
        tuple_destructuring ||
        enum_destructuring ||
        expression
    end
  end
end
