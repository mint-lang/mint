module Mint
  class Parser
    def spread
      parse do |start_position|
        next unless word! "..."

        next error :spread_expected_variable do
          expected "the name of a spread", word
          snippet self
        end unless variable = self.variable

        Ast::Spread.new(
          from: start_position,
          variable: variable,
          to: position,
          file: file)
      end
    end
  end
end
