module Mint
  class Parser
    syntax_error TypeExpectedClosingParentheses
    syntax_error TypeExpectedTypeOrVariable
    syntax_error TypeExpectedType

    def type!(error : SyntaxError.class) : Ast::Type
      start_position = position

      name = type_id! error

      if char! '('
        parameters = list(
          separator: ',',
          terminator: ')'
        ) do
          type =
            self.type(TypeExpectedType).as(Ast::Type | Nil) ||
              type_variable.as(Ast::TypeVariable | Nil)
          raise TypeExpectedTypeOrVariable unless type
          type
        end.compact
        char ')', TypeExpectedClosingParentheses
      end

      Ast::Type.new(
        parameters: parameters || [] of Ast::Type | Ast::Variable,
        from: start_position,
        to: position,
        input: data,
        name: name)
    end

    def type(error : SyntaxError.class = SyntaxError) : Ast::Type | Nil
      return unless char.in_set? "A-Z"
      type! error
    end
  end
end
