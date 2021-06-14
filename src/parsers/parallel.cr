module Mint
  class Parser
    syntax_error ParallelExpectedOpeningBracket
    syntax_error ParallelExpectedClosingBracket
    syntax_error ParallelExpectedStatement

    def parallel : Ast::Parallel?
      start do |start_position|
        next unless keyword "parallel"
        next unless whitespace?
        whitespace

        body = block(
          opening_bracket: ParallelExpectedOpeningBracket,
          closing_bracket: ParallelExpectedClosingBracket
        ) do
          results = many { statement(:sequence) || comment }

          raise ParallelExpectedStatement if results.none?(Ast::Statement)

          results
        end

        whitespace
        then_branch = then_block

        whitespace
        catches = many { catch }

        whitespace
        catch_all = self.catch_all

        statements = [] of Ast::Statement
        comments = [] of Ast::Comment

        body.each do |item|
          case item
          when Ast::Statement
            statements << item
          when Ast::Comment
            comments << item
          end
        end

        self << Ast::Parallel.new(
          then_branch: then_branch,
          statements: statements,
          catch_all: catch_all,
          from: start_position,
          comments: comments,
          finally: finally,
          catches: catches,
          to: position,
          input: data)
      end
    end
  end
end
