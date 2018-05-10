module Mint
  class Compiler
    def compile(node : Ast::Where) : String
      expression =
        compile node.expression

      "let #{node.name.value} = #{expression}"
    end
  end
end
