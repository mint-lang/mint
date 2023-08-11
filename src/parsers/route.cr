module Mint
  class Parser
    def route : Ast::Route?
      start do |start_position|
        next unless char.in?('*', '/')

        url =
          case char
          when '*'
            step
            "*"
          else
            gather { chars_until ' ', '\n', '\r', '\t', '{', '(' }.to_s
          end

        whitespace

        arguments = [] of Ast::Argument

        if char! '('
          arguments = list(terminator: ')', separator: ',') { argument(false) }
          whitespace

          next error :route_expected_closing_parenthesis do
            expected "the closing parenthesis of a route", word
            snippet self
          end unless char! ')'
          whitespace
        end

        body =
          code_block2(
            ->{ error :route_expected_opening_bracket do
              expected "the opening bracket of a route", word
              snippet self
            end },
            ->{ error :route_expected_closing_bracket do
              expected "the closing bracket of a route", word
              snippet self
            end },
            ->{ error :route_expected_body do
              expected "the body of a route", word
              snippet self
            end })

        self << Ast::Route.new(
          arguments: arguments,
          from: start_position,
          expression: body,
          to: position,
          input: data,
          url: url)
      end
    end
  end
end
