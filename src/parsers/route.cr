module Mint
  class Parser
    def route : Ast::Route?
      parse do |start_position|
        next unless char.in?('*', '/')

        url =
          if char! '*'
            "*"
          else
            gather { chars { |char| !char.in?(' ', '\n', '\r', '\t', '{', '(') } }.to_s
          end

        arguments = [] of Ast::Argument

        whitespace
        if char! '('
          arguments =
            list(terminator: ')', separator: ',') do
              argument(parse_default_value: false)
            end

          whitespace
          next error :route_expected_closing_parenthesis do
            expected "the closing parenthesis of a route", word
            snippet self
          end unless char! ')'
          whitespace
        end

        body =
          block(
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

        next unless body

        Ast::Route.new(
          arguments: arguments,
          from: start_position,
          expression: body,
          to: position,
          file: file,
          url: url)
      end
    end
  end
end
