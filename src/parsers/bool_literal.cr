module Mint
  class Parser
    def bool_literal : Ast::BoolLiteral?
      parse do |start_position|
        value =
          case
          when keyword! "true"
            true
          when keyword! "false"
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
