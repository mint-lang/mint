module Mint
  class Parser
    def signal_value : Ast::SignalValue?
      parse do |start_position|
        next unless char! '~'

        next error :signal_value_expected_expression do
          expected "the expression of a signal value extractor", word
          snippet self
        end unless expression = self.base_expression

        Ast::SignalValue.new(
          expression: expression,
          from: start_position,
          to: position,
          file: file)
      end
    end
  end
end
