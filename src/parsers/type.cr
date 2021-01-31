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
          whitespace
          type =
            self.type.as(Ast::Type?) ||
              type_variable.as(Ast::TypeVariable?)
          whitespace
          raise TypeExpectedTypeOrVariable unless type
          type
        end.compact
        char ')', TypeExpectedClosingParentheses
      end

      self << Ast::Type.new(
        parameters: parameters || [] of Ast::Type | Ast::TypeVariable,
        from: start_position,
        to: position,
        input: data,
        name: name)
    end

    def type : Ast::Type?
      return unless char.in_set? "A-Z"
      type! TypeExpectedType
    end
  end
end
