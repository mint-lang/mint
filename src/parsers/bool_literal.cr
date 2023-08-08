module Mint
  class Parser
    def bool_literal : Ast::BoolLiteral?
      parse do |start_position|
        value =
          case
          when word! "true"
            true
          when word! "false"
            false
          else
            next
          end

        Ast::BoolLiteral.new(
          from: start_position,
          value: value,
          to: position,
          file: file)
      end
    end
  end
end
