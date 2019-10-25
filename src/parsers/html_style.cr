module Mint
  class Parser
    syntax_error HtmlStyleExpectedClosingParentheses

    def html_style : Ast::HtmlStyle | Nil
      start do |start_position|
        name = start do
          skip unless keyword "::"
          skip unless value = variable_with_dashes
          value
        end

        skip unless name

        arguments = [] of Ast::Node

        if char! '('
          whitespace

          list(terminator: ')', separator: ',') do
            if item = expression
              arguments << item
            end
          end

          whitespace
          char ')', HtmlStyleExpectedClosingParentheses
        end

        Ast::HtmlStyle.new(
          arguments: arguments.compact,
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
