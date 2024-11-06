module Mint
  class Parser
    def emit : Ast::Emit?
      parse do |start_position|
        next unless keyword! "emit"

        whitespace
        next unless expression = self.expression

        Ast::Emit.new(
          expression: expression,
          from: start_position,
          to: position,
          file: file)
      end
    end
  end
end
