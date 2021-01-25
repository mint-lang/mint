module Mint
  class Parser
    syntax_error ParallelExpectedOpeningBracket
    syntax_error ParallelExpectedClosingBracket
    syntax_error ParallelExpectedStatement

    def parallel : Ast::Parallel?
      start do |start_position|
        skip unless keyword "parallel"

        whitespace! SkipError

        body = block(
          opening_bracket: ParallelExpectedOpeningBracket,
          closing_bracket: ParallelExpectedClosingBracket
        ) do
          results = many { statement(Ast::Statement::Parent::Sequence) || comment }.compact

          raise ParallelExpectedStatement if results
                                               .reject(Ast::Comment)
                                               .empty?
          results
        end

        whitespace
        then_branch = then_block

        whitespace
        catches = many { catch }.compact

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
          else
            # ignore
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
