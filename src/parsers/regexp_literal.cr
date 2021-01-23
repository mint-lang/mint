module Mint
  class Parser
    syntax_error RegexpLiteralExpectedClosingSlash

    def regexp_literal : Ast::RegexpLiteral?
      start do |start_position|
        skip unless char! '/'

        # This is a safe check because a regexp cannot start
        # with a quantifier.
        skip if char == '*'

        value = many(parse_whitespace: false) do
          not_interpolation_part('/', stop_on_interpolation: false)
        end.compact.join

        char "/", RegexpLiteralExpectedClosingSlash

        flags = gather { chars "igmsuy" }.to_s

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
