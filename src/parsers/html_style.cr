module Mint
  class Parser
    syntax_error HtmlStyleExpectedClosingParentheses
    syntax_error HtmlStyleExpectedDot

    def html_style : Ast::HtmlStyle?
      start do |start_position|
        head = start do
          next unless keyword "::"

          styles = type_id
          char '.', HtmlStyleExpectedDot if styles

          next unless value = variable_with_dashes

          {value, styles}
        end

        next unless head

        name, entity =
          head

        arguments =
          [] of Ast::Node

        if char! '('
          whitespace

          arguments = list(terminator: ')', separator: ',') { expression }

          whitespace
          char ')', HtmlStyleExpectedClosingParentheses
        end

        Ast::HtmlStyle.new(
          arguments: arguments,
          from: start_position,
          entity: entity,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
