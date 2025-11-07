module Mint
  class Parser
    def tag : Ast::Tag?
      parse do |start_position|
        next unless char! '\''
        next unless value = raw("'")

        next error :string_expected_closing_quote do
          expected "the closing quoute of a tag", word
          snippet self
        end unless char! '\''

        Ast::Tag.new(
          from: start_position,
          value: value,
          to: position,
          file: file)
      end
    end
  end
end
