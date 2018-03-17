class Parser
  syntax_error DoExpectedOpeningBracket
  syntax_error DoExpectedClosingBracket
  syntax_error DoExpectedStatement

  def do_expression : Ast::Do | Nil
    start do |start_position|
      skip unless keyword "do"

      whitespace! SkipError

      statements = block(
        opening_bracket: DoExpectedOpeningBracket,
        closing_bracket: DoExpectedClosingBracket
      ) do
        results = many { statement }.compact
        raise DoExpectedStatement if results.empty?
        results
      end

      whitespace

      catches = many { catch }.compact

      Ast::Do.new(
        statements: statements,
        from: start_position,
        finally: finally,
        catches: catches,
        to: position,
        input: data)
    end
  end
end
