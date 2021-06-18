module Mint
  class Parser
    syntax_error WhereExpectedOpeningBracket
    syntax_error WhereExpectedClosingBracket
    syntax_error WhereExpectedWhere

    def where : Ast::Where?
      start do |start_position|
        next unless keyword "where"

        body = block(
          opening_bracket: WhereExpectedOpeningBracket,
          closing_bracket: WhereExpectedClosingBracket
        ) do
          items = many { where_statement || comment }

          raise WhereExpectedWhere if items.none?(Ast::WhereStatement)

          items
        end

        statements = [] of Ast::WhereStatement
        comments = [] of Ast::Comment

        body.each do |item|
          case item
          when Ast::WhereStatement
            statements << item
          when Ast::Comment
            comments << item
          end
        end

        self << Ast::Where.new(
          statements: statements,
          from: start_position,
          comments: comments,
          to: position,
          input: data)
      end
    end
  end
end
