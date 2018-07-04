module Mint
  class Parser
    syntax_error DoExpectedOpeningBracket
    syntax_error DoExpectedClosingBracket
    syntax_error DoExpectedStatement

    def do_expression : Ast::Do | Nil
      start do |start_position|
        skip unless keyword "do"

        whitespace! SkipError

        body = block(
          opening_bracket: DoExpectedOpeningBracket,
          closing_bracket: DoExpectedClosingBracket
        ) do
          results = many { statement || comment }.compact

          raise DoExpectedStatement if results
                                         .select(&.is_a?(Ast::Statement))
                                         .empty?
          results
        end

        whitespace

        catches = many { catch }.compact

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

        Ast::Do.new(
          statements: statements,
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
