module Mint
  class Parser
    def access(expression : Ast::Node) : Ast::Access?
      parse do
        next unless char! '.'

        next error :access_expected_field do
          expected "the name of the accessed entity", word
          snippet self
        end unless field = value

        Ast::Access.new(
          expression: expression,
          from: expression.from,
          field: field,
          to: position,
          file: file)
      end
    end
  end
end
