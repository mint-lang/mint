module Mint
  class Parser
    # NOTE: The order of the parsing is important!
    def basic_expression : Ast::Expression | Nil
      env ||
        string_literal ||
        bool_literal ||
        number_literal ||
        array ||
        record_update ||
        record ||
        html_element ||
        html_component ||
        html_fragment ||
        access ||
        module_call ||
        module_access ||
        decode ||
        encode ||
        if_expression ||
        with_expression ||
        next_call ||
        sequence ||
        parallel ||
        try_expression ||
        case_expression ||
        function_call ||
        inline_function_or_parenthesized_expression ||
        negated_expression ||
        enum_id ||
        js ||
        void ||
        variable
    end

    def inline_function_or_parenthesized_expression : Ast::InlineFunction | Ast::ParenthesizedExpression | Nil
      parenthesized_expression
    rescue error1
      begin
        inline_function
      rescue error2
        raise error2
      end
    end

    def basic_expression!(error : SyntaxError.class) : Ast::Expression
      raise error unless exp = basic_expression
      exp
    end
  end
end
