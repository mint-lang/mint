module Mint
  class Parser
    def js : Ast::Js?
      parse do |start_position|
        next unless char! '`'

        value =
          many(parse_whitespace: false) do
            raw('`') || interpolation { builtin || expression }
          end

        next error :js_expected_closing_tick do
          expected "the closing tick of an inlined JavaScript", word
          snippet self
        end unless char! '`'
        whitespace

        if keyword! "as"
          whitespace
          next error :js_expected_type_or_variable do
            expected "the type of an inlined JavaScript", word
            snippet self
          end unless type = self.type || type_variable
        end

        Ast::Js.new(
          from: start_position,
          value: value,
          to: position,
          type: type,
          file: file)
      end
    end
  end
end
