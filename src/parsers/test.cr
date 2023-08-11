module Mint
  class Parser
    def test : Ast::Test?
      start do |start_position|
        next unless keyword "test"

        whitespace

        next error :test_expected_name do
          expected "the name of a test", word
          snippet self
        end unless name = string_literal with_interpolation: false

        whitespace

        expression =
          code_block2(
            ->{ error :test_expected_opening_bracket do
              expected "the opening bracket of a test", word
              snippet self
            end },
            ->{ error :test_expected_closing_bracket do
              expected "the closing bracket of a test", word
              snippet self
            end },
            ->{ error :test_expected_body do
              expected "the body of a test", word
              snippet self
            end })

        self << Ast::Test.new(
          expression: expression,
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
