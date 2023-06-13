module Mint
  class Parser
    syntax_error RoutesExpectedOpeningBracket
    syntax_error RoutesExpectedClosingBracket
    syntax_error RoutesExpectedRoute

    def routes : Ast::Routes?
      start do |start_position|
        next unless keyword "routes"

        body = block(
          opening_bracket: RoutesExpectedOpeningBracket,
          closing_bracket: RoutesExpectedClosingBracket
        ) do
          items = many { comment || route }

          raise RoutesExpectedRoute if items.none?(Ast::Route)

          items
        end

        comments = [] of Ast::Comment
        routes = [] of Ast::Route

        body.each do |item|
          case item
          when Ast::Route
            routes << item
          when Ast::Comment
            comments << item
          end
        end

        self << Ast::Routes.new(
          from: start_position,
          comments: comments,
          routes: routes,
          to: position,
          input: data)
      end
    end
  end
end
