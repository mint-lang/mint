module Mint
  class Parser
    syntax_error RouteExpectedClosingParentheses
    syntax_error RouteExpectedOpeningBracket
    syntax_error RouteExpectedClosingBracket
    syntax_error RouteExpectedExpression

    def route : Ast::Route | Nil
      start do |start_position|
        skip unless char.in_set? "*/"

        url =
          if char == "*"
            step
            "*"
          else
            gather { chars "^ \n\r\t{(" }.to_s
          end

        whitespace

        arguments = [] of Ast::Argument

        if char! '('
          arguments.concat list(
            terminator: ')',
            separator: ','
          ) { argument }.compact
          whitespace
          char ')', RouteExpectedClosingParentheses
        end

        body = block(
          opening_bracket: RouteExpectedOpeningBracket,
          closing_bracket: RouteExpectedClosingBracket
        ) do
          expression! RouteExpectedExpression
        end

        Ast::Route.new(
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
