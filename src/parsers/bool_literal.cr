module Mint
  class Parser
    def bool_literal : Ast::BoolLiteral?
      start do |start_position|
        value =
          if keyword "true"
            true
          elsif keyword "false"
            false
          end

        skip if value.nil?

        self << Ast::BoolLiteral.new(
          from: start_position,
          value: value,
          to: position,
          input: data)
      end
    end
  end
end
