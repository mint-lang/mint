module Mint
  class Parser
    def use : Ast::Use?
      start do |start_position|
        next unless keyword "use"

        whitespace
        next error :use_expected_provider do
          expected "the provider of a use", word
          snippet self
        end unless provider = type_id

        whitespace
        next error :use_expected_record do
          expected "the record of a use", word
          snippet self
        end unless item = record
        whitespace

        if keyword "when"
          condition = block2(
            ->{ error :use_expected_condition_opening_bracket do
              expected "the opening bracket of a use condition", word
              snippet self
            end },
            ->{ error :use_expected_condition_closing_bracket do
              expected "the closing bracket of a use condition", word
              snippet self
            end }
          ) do
            next error :use_expected_condition do
              expected "the condition of a use", word
              snippet self
            end unless exp = expression
            exp
          end
        end

        self << Ast::Use.new(
          from: start_position,
          condition: condition,
          provider: provider,
          to: position,
          input: data,
          data: item)
      end
    end
  end
end
