module Mint
  class Parser
    syntax_error RouteExpectedClosingParentheses
    syntax_error RouteExpectedOpeningBracket
    syntax_error RouteExpectedClosingBracket
    syntax_error RouteExpectedExpression

    def route : Ast::Route?
      start do |start_position|
        next unless char.in?('*', '/')

        url =
          case char
          when '*'
            step
            "*"
          else
            gather { chars "^ \n\r\t{(" }.to_s
          end

        whitespace

        arguments = [] of Ast::Argument

        if char! '('
          arguments = list(terminator: ')', separator: ',') { argument }
          whitespace
          char ')', RouteExpectedClosingParentheses
          whitespace
        end

        body =
          code_block(
            opening_bracket: RouteExpectedOpeningBracket,
            closing_bracket: RouteExpectedClosingBracket,
            statement_error: RouteExpectedExpression)

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
