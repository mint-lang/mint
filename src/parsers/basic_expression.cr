module Mint
  class Parser
    # NOTE: The order of the parsing is important!
    def basic_expression : Ast::Expression?
      format_directive ||
        documentation_directive ||
        svg_directive ||
        asset_directive ||
        inline_directive ||
        env ||
        string_literal ||
        regexp_literal ||
        bool_literal ||
        number_literal ||
        unary_minus ||
        array ||
        record_update ||
        tuple_literal_or_record_or_block ||
        html_element ||
        html_expression ||
        html_component ||
        html_fragment ||
        member_access ||
        constant_access ||
        module_access ||
        decode ||
        encode ||
        if_expression ||
        for_expression ||
        next_call ||
        sequence ||
        case_expression ||
        parenthesized_expression_or_inline_function ||
        starts_with_uppercase ||
        negated_expression ||
        js ||
        void ||
        variable
    end

    def tuple_literal_or_record_or_block : Ast::TupleLiteral | Ast::Record?
      tuple_literal
    rescue
      begin
        record
      rescue error
        begin
          code_block(SyntaxError, SyntaxError)
        rescue
          raise error
        end
      end
    end

    def starts_with_uppercase
      item = enum_id rescue nil
      item ||= record_constructor rescue nil

      return item if item

      constant_variable
    end

    def parenthesized_expression_or_inline_function : Ast::ParenthesizedExpression | Ast::InlineFunction?
      parenthesized_expression
    rescue
      inline_function
    end

    def basic_expression!(error : SyntaxError.class) : Ast::Expression
      basic_expression || raise error
    end
  end
end
