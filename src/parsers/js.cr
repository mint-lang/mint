module Mint
  class Parser
    syntax_error JsExpectedClosingTick

    def js : Ast::Js | Nil
      start do |start_position|
        skip unless char! '`'

        value = js_part

        char '`', JsExpectedClosingTick

        Ast::Js.new(
          from: start_position,
          value: value.to_s,
          to: position,
          input: data)
      end
    end

    def js_part : String
      value = gather { chars "^`" }.to_s
      return value unless prev_char == '\\'
      char! '`'
      value.rchop + '`' + js_part
    end
  end
end
