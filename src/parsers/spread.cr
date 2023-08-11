module Mint
  class Parser
    def spread
      start do |start_position|
        next unless keyword "..."

        next error :spread_expected_variable do
          expected "the name of a spread", word
          snippet self
        end unless variable = self.variable

        Ast::Spread.new(
          from: start_position,
          variable: variable,
          to: position,
          input: data)
      end
    end
  end
end
