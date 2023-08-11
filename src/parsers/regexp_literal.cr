module Mint
  class Parser
    def regexp_literal : Ast::RegexpLiteral?
      start do |start_position|
        next unless char! '/'

        # This is a safe check because a regexp cannot start
        # with a quantifier.
        next if char == '*'

        value = many(parse_whitespace: false) do
          not_interpolation_part('/', stop_on_interpolation: false)
        end.join

        next error :regexp_literal_expected_closing_slash do
          expected "the closing slash of a regexp literal", word
          snippet self
        end unless char! '/'

        flags = gather { chars 'i', 'g', 'm', 's', 'u', 'y' }.to_s

        Ast::RegexpLiteral.new(
          from: start_position,
          value: value,
          flags: flags,
          to: position,
          input: data)
      end
    end
  end
end
