module Mint
  class Parser
    syntax_error JsExpectedClosingTick

    def js : Ast::Js | Nil
      start do |start_position|
        skip unless char! '`'

        value = many(parse_whitespace: false) do
          (js_part || js_interpolation).as(Ast::Node | String | Nil)
        end.compact

        char '`', JsExpectedClosingTick

        Ast::Js.new(
          from: start_position,
          value: value,
          to: position,
          input: data)
      end
    end

    def js_part : String | Nil
      # We geather characters until we find either a backtick or interpolation
      value = gather { chars "^`#" }

      if char == '#' && next_char != '{'
        # If we found a hashtag then it could be an interpolation, if
        # not we consume the character and return.
        step
        value.to_s + '#'
      elsif char == '#' && prev_char == '\\'
        # if we found a backtick and the previous char is backslash then it
        # means it's an escape so we consume it and return.
        step

        # The rchop here removes the escape slash "\"
        value.to_s.rchop + "#"
      elsif char == '`' && prev_char == '\\'
        # if we found a backtick and the previous char is backslash then it
        # means it's an escape so we consume it and return.
        step

        # The rchop here removes the escape slash "\"
        value.to_s.rchop + '`'
      else
        value
      end
    end
  end
end
