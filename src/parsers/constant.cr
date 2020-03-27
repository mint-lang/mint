module Mint
  class Parser
    syntax_error ConstantExpectedEqualSign
    syntax_error ConstantExpectedValue
    syntax_error ConstantExpectedName

    def constant : Ast::Constant | Nil
      start do |start_position|
        comment = self.comment
        whitespace

        skip unless keyword "const"
        whitespace

        head =
          gather { chars("A-Z") }.to_s

        tail =
          gather { chars("A-Z_") }.to_s

        name =
          "#{head}#{tail}"

        raise ConstantExpectedName if name.empty?

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
