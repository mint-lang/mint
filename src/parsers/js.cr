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
      value = gather { chars "^`$" }

      return unless value
      return value unless prev_char == '\\'

      char! '`'
      next_part = js_part

      if next_part
        value.rchop + '`' + next_part
      else
        value.rchop + '`'
      end
    end
  end
end
