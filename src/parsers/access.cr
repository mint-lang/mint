module Mint
  class Parser
    def access(expression : Ast::Node) : Ast::Access?
      parse do
        # TODO: Remove this in 0.21.0
        type =
          if word! "::"
            Ast::Access::Type::DoubleColon
          elsif char! ':'
            Ast::Access::Type::Colon
          elsif char! '.'
            Ast::Access::Type::Dot
          end

        next unless type

        next error :access_expected_field do
          expected "the name of the accessed entity", word
          snippet self
        end unless field = value

        Ast::Access.new(
          expression: expression,
          from: expression.from,
          field: field,
          to: position,
          file: file,
          type: type)
      end
    end
  end
end
