module Mint
  class Parser
    syntax_error SequenceExpectedOpeningBracket
    syntax_error SequenceExpectedClosingBracket
    syntax_error SequenceExpectedStatement

    def sequence : Ast::Sequence?
      start do |start_position|
        next unless keyword "sequence"
        next unless whitespace?
        whitespace

        body = block(
          opening_bracket: SequenceExpectedOpeningBracket,
          closing_bracket: SequenceExpectedClosingBracket
        ) do
          results = many { statement(:sequence) || comment }

          raise SequenceExpectedStatement if results.none?(Ast::Statement)

          results
        end

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
