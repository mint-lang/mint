module Mint
  class Parser
    syntax_error ConstantExpectedEqualSign
    syntax_error ConstantExpectedValue
    syntax_error ConstantExpectedName

    def constant : Ast::Constant?
      start do |start_position|
        comment = self.comment
        whitespace

        next unless keyword("const", true)
        whitespace

        name = variable_constant!

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
