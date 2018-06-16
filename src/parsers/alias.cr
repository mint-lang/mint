module Mint
  class Parser
    syntax_error AliasExpectedEqualSign
    syntax_error AliasExpectedType
    syntax_error AliasExpectedName

    def alias : Ast::Alias | Nil
      start do |start_position|
        skip unless keyword "alias"

        whitespace! SkipError

        name = type_id! AliasExpectedName

        whitespace
        char "=", AliasExpectedEqualSign
        whitespace

        base = type! AliasExpectedType

        types = many do
          next unless char! '|'
          whitespace
          type! AliasExpectedType
        end

        Ast::Alias.new(
          types: ([base] + types).compact,
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
