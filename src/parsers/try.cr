module Mint
  class Parser
    syntax_error TryExpectedOpeningBracket
    syntax_error TryExpectedClosingBracket
    syntax_error TryExpectedStatement

    def try_expression : Ast::Try | Nil
      start do |start_position|
        skip unless keyword "try"

        body = block(
          opening_bracket: TryExpectedOpeningBracket,
          closing_bracket: TryExpectedClosingBracket
        ) do
          items = many { statement || comment }.compact

          raise TryExpectedStatement if items
                                          .reject(&.is_a?(Ast::Comment))
                                          .empty?

          items
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
          end
        end

        Ast::Try.new(
          statements: statements,
          catch_all: catch_all,
          from: start_position,
          comments: comments,
          catches: catches,
          to: position,
          input: data)
      end
    end
  end
end
