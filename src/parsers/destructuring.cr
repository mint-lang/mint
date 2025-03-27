module Mint
  class Parser
    def destructuring : Ast::Node?
      array_destructuring ||
        record_destructuring ||
        tuple_destructuring ||
        type_destructuring ||
        string_literal(with_interpolation: false) ||
        number_literal ||
        bool_literal ||
        variable ||
        discard
    end
  end
end
