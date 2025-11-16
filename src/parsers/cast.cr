module Mint
  class Parser
    def cast(expression : Ast::Node) : Ast::Node
      parse do |start_position|
        whitespace
        next unless keyword! "cast"
        whitespace

        next unless type = self.type

        Ast::Cast.new(
          expression: expression,
          from: start_position,
          to: position,
          file: file,
          type: type)
      end || expression
    end
  end
end
