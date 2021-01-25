module Mint
  class Parser
    syntax_error AccessExpectedVariable

    def access(lhs : Ast::Expression, safe : Bool = false) : Ast::Expression
      start do |start_position|
        if safe
          keyword! "&.", SkipError
        else
          char '.', SkipError
        end

        field = variable! AccessExpectedVariable

        node = self << Ast::Access.new(
          lhs: lhs,
          safe: safe,
          field: field,
          from: start_position,
          to: position,
          input: data)

        array_access_or_call(node)
      end || lhs
    end
  end
end
