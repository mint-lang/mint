module Mint
  class Parser
    syntax_error AccessExpectedVariable

    def access(lhs : Ast::Expression) : Ast::Expression
      start do |start_position|
        next unless char! '.'

        field = variable! AccessExpectedVariable, track: false

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
