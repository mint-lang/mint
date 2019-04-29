module Mint
  class Parser
    syntax_error MemberAccessExpectedVariable

    def member_access : Ast::MemberAccess | Nil
      start do |start_position|
        skip unless char! '.'

        name = variable! MemberAccessExpectedVariable

        Ast::MemberAccess.new(
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
