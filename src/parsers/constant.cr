module Mint
  class Parser
    syntax_error ConstantExpectedEqualSign
    syntax_error ConstantExpectedValue
    syntax_error ConstantExpectedName

    def constant : Ast::Constant?
      start do |start_position|
        comment = self.comment
        whitespace

        next unless keyword "const"
        whitespace

        head =
          gather { chars("A-Z") }

        tail =
          gather { chars("A-Z0-9_") }

        raise ConstantExpectedName unless head || tail

        name =
          "#{head}#{tail}"

        whitespace
        char '=', ConstantExpectedEqualSign
        whitespace

        value = expression! ConstantExpectedValue

        Ast::Constant.new(
          from: start_position,
          comment: comment,
          value: value,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
