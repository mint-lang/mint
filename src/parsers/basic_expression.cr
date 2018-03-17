class Parser
  # NOTE: The order of the parsing is important!
  def basic_expression : Ast::Expression | Nil
    string_literal ||
      bool_literal ||
      number_literal ||
      array ||
      record_update ||
      record ||
      html_element ||
      html_component ||
      access ||
      module_call ||
      module_access ||
      if_expression ||
      with_expression ||
      next_call ||
      do_expression ||
      try_expression ||
      case_expression ||
      inline_function ||
      function_call ||
      parenthesized_expression ||
      js ||
      void ||
      variable
  end

  def basic_expression!(error : SyntaxError.class) : Ast::Expression
    raise error unless exp = basic_expression
    exp
  end
end
