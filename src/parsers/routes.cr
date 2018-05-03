module Mint
  class Parser
    syntax_error RoutesExpectedOpeningBracket
    syntax_error RoutesExpectedClosingBracket
    syntax_error RoutesExpectedRoute

    def routes : Ast::Routes | Nil
      start do |start_position|
        skip unless keyword "routes"

        routes = block(
          opening_bracket: RoutesExpectedOpeningBracket,
          closing_bracket: RoutesExpectedClosingBracket
        ) do
          items = many { route }.compact
          raise RoutesExpectedRoute if items.empty?
          items
        end

        Ast::Routes.new(
          from: start_position,
          routes: routes,
          to: position,
          input: data)
      end
    end
  end
end
