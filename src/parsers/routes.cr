module Mint
  class Parser
    def routes : Ast::Routes?
      start do |start_position|
        next unless keyword "routes"

        body =
          block2(
            ->{ error :routes_expected_opening_bracket do
              expected "the opening bracket of a routes block", word
              snippet self
            end },
            ->{ error :routes_expected_closing_bracket do
              expected "the closing bracket of a routes block", word
              snippet self
            end }) do
            items = many { comment || route }

            next error :routes_expected_body do
              expected "the body of a routes block", word
              snippet self
            end if items.none?(Ast::Route)

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
