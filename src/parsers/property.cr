module Mint
  class Parser
    syntax_error PropertyExpectedDefaultValue
    syntax_error PropertyExpectedName
    syntax_error PropertyExpectedType

    def property : Ast::Property | Nil
      start do
        comment = self.comment
        whitespace

        start_position = position

        skip unless keyword "property"
        whitespace

        name = variable! PropertyExpectedName
        whitespace

        type =
          if char! ':'
            whitespace
            item = type! PropertyExpectedType
            whitespace
            item
          end

        default =
          if char! '='
            whitespace
            expression! PropertyExpectedDefaultValue
          end

        Ast::Property.new(
          from: start_position,
          comment: comment,
          default: default,
          to: position,
          input: data,
          type: type,
          name: name)
      end
    end
  end
end
