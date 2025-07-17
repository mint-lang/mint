module Mint
  class Parser
    def use : Ast::Use?
      parse do |start_position|
        is_use =
          keyword!("use")

        next unless is_use || keyword!("provide")
        whitespace

        next error :use_expected_provider do
          expected "the provider of a use", word
          snippet self
        end unless provider = id
        whitespace

        next error :use_expected_record do
          expected "the record of a use", word
          snippet self
        end unless data = record

        condition =
          if is_use
            parse(track: false) do
              whitespace
              next unless keyword! "when"
              whitespace

              brackets(
                -> { error :use_expected_condition_opening_bracket do
                  expected "the opening bracket of a use condition", word
                  snippet self
                end },
                -> { error :use_expected_condition_closing_bracket do
                  expected "the closing bracket of a use condition", word
                  snippet self
                end },
                ->(item : Ast::Node?) {
                  error :use_expected_condition do
                    expected "the condition of a use", word
                    snippet self
                  end unless item
                }) { expression }
            end
          end

        Ast::Use.new(
          from: start_position,
          condition: condition,
          provider: provider,
          context: !is_use,
          to: position,
          file: file,
          data: data)
      end
    end
  end
end
