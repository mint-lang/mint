module Mint
  class Parser
    syntax_error SequenceExpectedOpeningBracket
    syntax_error SequenceExpectedClosingBracket
    syntax_error SequenceExpectedStatement

    def sequence : Ast::Sequence?
      start do |start_position|
        skip unless keyword "sequence"

        whitespace! SkipError

        body = block(
          opening_bracket: SequenceExpectedOpeningBracket,
          closing_bracket: SequenceExpectedClosingBracket
        ) do
          results = many { statement(Ast::Statement::Parent::Sequence) || comment }.compact

          raise SequenceExpectedStatement if results
                                               .select(Ast::Statement)
                                               .empty?
          results
        end

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

        self << Ast::Sequence.new(
          statements: statements,
          from: start_position,
          catch_all: catch_all,
          comments: comments,
          finally: finally,
          catches: catches,
          to: position,
          input: data)
      end
    end
  end
end
