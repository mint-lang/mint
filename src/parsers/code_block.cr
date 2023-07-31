module Mint
  class Parser
    def code_block_naked : Ast::Block?
      start do |start_position|
        statements =
          many { comment || statement }

        self << Ast::Block.new(
          statements: statements,
          from: start_position,
          to: position,
          input: data) if statements
      end
    end

    def code_block : Ast::Block?
      start do |start_position|
        statements =
          block do
            many { comment || statement }
          end

        self << Ast::Block.new(
          statements: statements,
          from: start_position,
          to: position,
          input: data) if statements
      end
    end

    def code_block(opening_bracket : SyntaxError.class,
                   closing_bracket : SyntaxError.class,
                   statement_error : SyntaxError.class = SyntaxError) : Ast::Block?
      start do |start_position|
        statements =
          block(
            opening_bracket: opening_bracket,
            closing_bracket: closing_bracket) do
            many { comment || statement }.tap do |items|
              raise statement_error if items.none?
            end
          end

        self << Ast::Block.new(
          statements: statements,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
