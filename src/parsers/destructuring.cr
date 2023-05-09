module Mint
  class Parser
    def destructuring : Ast::Node?
      constant_access ||
        array_destructuring ||
        tuple_destructuring ||
        enum_destructuring ||
        expression
    end
  end
end
