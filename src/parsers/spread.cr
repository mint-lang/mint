module Mint
  class Parser
    syntax_error SpreadExpectedVariable

    def spread
      start do |start_position|
        skip unless keyword "..."

        variable = variable! SpreadExpectedVariable

        Ast::Spread.new(
          from: start_position,
          variable: variable,
          to: position,
          input: data)
      end
    end
  end
end
