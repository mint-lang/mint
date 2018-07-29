module Mint
  class Parser
    syntax_error StateExpectedDefaultValue
    syntax_error StateExpectedEqualSign
    syntax_error StateExpectedColon
    syntax_error StateExpectedName
    syntax_error StateExpectedType

    def state : Ast::State | Nil
      start do |start_position|
        skip unless keyword "state"

        whitespace
        name = variable! StateExpectedName

        whitespace
        char ':', StateExpectedColon
        whitespace

        type = type! StateExpectedType

        whitespace
        char '=', StateExpectedEqualSign
        whitespace

        default = expression! StateExpectedDefaultValue

        Ast::State.new(
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
