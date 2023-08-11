module Mint
  class Parser
    def member_access : Ast::MemberAccess?
      start do |start_position|
        next unless char! '.'

        next error :member_access_expected_variable do
          expected "the field of the accessed entity", word
          snippet self
        end unless name = variable

        Ast::MemberAccess.new(
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
