module Mint
  class Parser
    # NOTE: The order of the parsing is important!
    def basic_expression : Ast::Expression | Nil
      env ||
        string_literal ||
        bool_literal ||
        number_literal ||
        unary_minus ||
        array ||
        record_update ||
        tuple_literal_or_record ||
        html_element ||
        html_component ||
        html_fragment ||
        member_access ||
        constant_access ||
        module_access ||
        decode ||
        encode ||
        if_expression ||
        for_expression ||
        with_expression ||
        next_call ||
        sequence ||
        parallel ||
        try_expression ||
        case_expression ||
        inline_function_or_parenthesized_expression ||
        starts_with_uppercase ||
        negated_expression ||
        js ||
        void ||
        variable
    end

    def tuple_literal_or_record
      tuple_literal
    rescue error1
      record
    end

    def starts_with_uppercase
      item = enum_id rescue nil
      item ||= record_constructor rescue nil

      return item if item

      constant_variable
    end

    def inline_function_or_parenthesized_expression : Ast::InlineFunction | Ast::ParenthesizedExpression | Nil
      parenthesized_expression
    rescue error1
      inline_function
    end

    def basic_expression!(error : SyntaxError.class) : Ast::Expression
      raise error unless exp = basic_expression
      exp
    end
  end
end
