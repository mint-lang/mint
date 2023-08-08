module Mint
  class Parser
    def routes : Ast::Routes?
      parse do |start_position|
        next unless word! "routes"
        whitespace

        body =
          brackets(
            ->{ error :routes_expected_opening_bracket do
              expected "the opening bracket of a routes block", word
              snippet self
            end },
            ->{ error :routes_expected_closing_bracket do
              expected "the closing bracket of a routes block", word
              snippet self
            end },
            ->(items : Array(Ast::Node)) {
              error :routes_expected_body do
                expected "the body of a routes block", word
                snippet self
              end if items.none?(Ast::Route)
            }) { many { comment || route } }

        next unless body

        comments = [] of Ast::Comment
        routes = [] of Ast::Route

        body.each do |item|
          case item
          when Ast::Comment
            comments << item
          when Ast::Route
            routes << item
          end
        end

        Ast::Routes.new(
          from: start_position,
          comments: comments,
          routes: routes,
          to: position,
          file: file)
      end
    end
  end
end
