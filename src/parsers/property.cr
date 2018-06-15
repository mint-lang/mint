module Mint
  class Parser
    syntax_error PropertyExpectedDefaultValue
    syntax_error PropertyExpectedEqualSign
    syntax_error PropertyExpectedColon
    syntax_error PropertyExpectedName
    syntax_error PropertyExpectedType

    def property : Ast::Property | Nil
      start do |start_position|
        skip unless keyword "property"

        whitespace
        name = variable! PropertyExpectedName

        whitespace
        char ':', PropertyExpectedColon
        whitespace

        type = type! PropertyExpectedType

        whitespace
        char '=', PropertyExpectedEqualSign
        whitespace

        default = expression! PropertyExpectedDefaultValue

        Ast::Property.new(
          default: default.as(Ast::Expression),
          from: start_position,
          to: position,
          input: data,
          type: type,
          name: name)
      end
    end
  end
end
