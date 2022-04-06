module Mint
  class Parser
    syntax_error JsExpectedTypeOrVariable
    syntax_error JsExpectedClosingTick

    def js : Ast::Js?
      start do |start_position|
        next unless char! '`'

        value = many(parse_whitespace: false) do
          (not_interpolation_part('`') || interpolation).as(Ast::Interpolation | String?)
        end

        char '`', JsExpectedClosingTick

        type = start do
          whitespace
          next unless keyword "as"
          whitespace
          type_or_type_variable! JsExpectedTypeOrVariable
        end

        self << Ast::Js.new(
          from: start_position,
          value: value,
          type: type,
          to: position,
          input: data)
      end
    end

    def not_interpolation_part(terminator : Char, stop_on_interpolation : Bool = true) : String?
      value =
        if stop_on_interpolation
          # Until we find either a terminator or interpolation
          gather { chars_until terminator, '#' }
        else
          # Until we find the terminator
          gather { chars_until terminator }
        end

      if prev_char == '\\'
        # if we found backslashthen it means it's an escape so we consume it
        step

        # if we are in an inline JavaScript
        if prev_char == '`' && terminator == '`'
          value.to_s.rchop + prev_char
        else
          value.to_s + prev_char
        end
      elsif char == '#' && next_char != '{' && stop_on_interpolation
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
