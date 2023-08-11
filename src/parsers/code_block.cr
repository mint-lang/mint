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

    def code_block2(opening_bracket_error : Proc(Nil)? = nil,
                    closing_bracket_error : Proc(Nil)? = nil,
                    statement_error : Proc(Nil)? = nil) : Ast::Block?
      start do |start_position|
        statements =
          block2(
            opening_bracket_error: opening_bracket_error,
            closing_bracket_error: closing_bracket_error) do
            many { comment || statement }.tap do |items|
              next statement_error.call if statement_error && items.none?
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
