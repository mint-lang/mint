module Mint
  class Parser
    def bool_literal : Ast::BoolLiteral?
      start do |start_position|
        value =
          case
          when keyword "true"
            true
          when keyword "false"
            false
          else
            next
          end

        self << Ast::BoolLiteral.new(
          from: start_position,
          value: value,
          to: position,
          input: data)
      end
    end
  end
end
