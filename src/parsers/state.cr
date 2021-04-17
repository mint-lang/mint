module Mint
  class Parser
    syntax_error StateExpectedDefaultValue
    syntax_error StateExpectedEqualSign
    syntax_error StateExpectedName
    syntax_error StateExpectedType

    def state : Ast::State?
      start do |start_position|
        comment = self.comment
        whitespace

        skip unless keyword "state"
        whitespace

        name = variable! StateExpectedName
        whitespace

        type =
          if char! ':'
            whitespace
            item = type! StateExpectedType
            whitespace
            item
          end

        whitespace
        char '=', StateExpectedEqualSign
        whitespace

        default = expression! StateExpectedDefaultValue

        self << Ast::State.new(
          default: default,
          from: start_position,
          comment: comment,
          to: position,
          input: data,
          type: type,
          name: name)
      end
    end
  end
end
