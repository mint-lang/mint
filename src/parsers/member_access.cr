module Mint
  class Parser
    syntax_error MemberAccessExpectedVariable

    def member_access : Ast::MemberAccess?
      start do |start_position|
        next unless char! '.'

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
