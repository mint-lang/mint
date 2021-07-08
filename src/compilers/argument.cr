module Mint
  class Compiler
    def _compile(node : Ast::Argument) : String
      name =
        js.variable_of(node)

      default =
        node.default.try { |item| " = #{compile item}" }

      "#{name}#{default}"
    end
  end
end
