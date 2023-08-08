module Mint
  class Parser
    def access(lhs : Ast::Expression) : Ast::Expression
      start do |start_position|
        next unless char! '.'

        next error :access_expected_entity do
          expected "the name of the accessed entity", word
          snippet self
        end unless field = variable

        node = self << Ast::Access.new(
          from: start_position,
          field: field,
          to: position,
          input: data,
          lhs: lhs)

        array_access_or_call(node)
      end || lhs
    end
  end
end
