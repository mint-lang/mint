module Mint
  class Parser
    def js : Ast::Js?
      parse do |start_position|
        next unless char! '`'

        value =
          many(parse_whitespace: false) do
            raw('`').try(&.gsub("\\`", '`')) || interpolation
          end

        next error :js_expected_closing_tick do
          expected "the closing tick of an inlined JavaScript", word
          snippet self
        end unless char! '`'
        whitespace

        if word! "as"
          whitespace
          next error :js_expected_type_or_variable do
            expected "the type of an inlined JavaScript", word
            snippet self
          end unless type = self.type || type_variable
        end

        Ast::Js.new(
          from: start_position,
          value: value,
          type: type,
          to: position,
          file: file)
      end
    end
  end
end
