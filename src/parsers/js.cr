module Mint
  class Parser
    def js : Ast::Js?
      start do |start_position|
        next unless char! '`'

        value = many(parse_whitespace: false) do
          (not_interpolation_part('`') || interpolation).as(Ast::Interpolation | String?)
        end

        next error :js_expected_closing_tick do
          expected "the closing tick of an inlined JavaScript", word
          snippet self
        end unless char! '`'

        whitespace
        if keyword "as"
          whitespace

          next error :js_expected_type_or_variable do
            expected "the type of an inlined JavaScript", word
            snippet self
          end unless type = type_or_type_variable
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
