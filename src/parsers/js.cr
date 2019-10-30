module Mint
  class Parser
    syntax_error JsExpectedClosingTick

    def js : Ast::Js | Nil
      start do |start_position|
        skip unless char! '`'

        value = many(parse_whitespace: false) do
          (not_interpolation_part('`') || interpolation).as(Ast::Interpolation | String | Nil)
        end.compact

        char '`', JsExpectedClosingTick

        Ast::Js.new(
          from: start_position,
          value: value,
          to: position,
          input: data)
      end
    end

    def not_interpolation_part(terminator : Char) : String | Nil
      # We geather characters until we find either a backtick or interpolation
      value = gather { chars "^#{terminator}#" }

      if prev_char == '\\'
        # if we found a terminator or hashtag and the previous char is backslash
        # then it means it's an escape so we consume it and return.
        step

        value.to_s + prev_char
      elsif char == '#' && next_char != '{'
        # If we found a hashtag then it could be an interpolation, if
        # not we consume the character and return.
        step
        value.to_s + '#'
      else
        value
      end
    end
  end
end
