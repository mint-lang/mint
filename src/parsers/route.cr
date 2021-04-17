module Mint
  class Parser
    syntax_error RouteExpectedClosingParentheses
    syntax_error RouteExpectedOpeningBracket
    syntax_error RouteExpectedClosingBracket
    syntax_error RouteExpectedExpression

    def route : Ast::Route?
      start do |start_position|
        skip unless char.in?('*', '/')

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
          arguments.concat list(
            terminator: ')',
            separator: ','
          ) { argument }.compact
          whitespace
          char ')', RouteExpectedClosingParentheses
        end

        head_comments, body, tail_comments = block_with_comments(
          opening_bracket: RouteExpectedOpeningBracket,
          closing_bracket: RouteExpectedClosingBracket
        ) do
          expression! RouteExpectedExpression
        end

        self << Ast::Route.new(
          head_comments: head_comments,
          tail_comments: tail_comments,
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
