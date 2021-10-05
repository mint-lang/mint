module Mint
  class Parser
    def code_block : Ast::Block?
      start do |start_position|
        char '{', SyntaxError
        whitespace

        statements =
          many { comment || statement(:none) }

        whitespace
        char '}', SyntaxError

        self << Ast::Block.new(
          statements: statements,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
