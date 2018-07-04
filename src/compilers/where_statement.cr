module Mint
  class Compiler
    def compile(node : Ast::WhereStatement) : String
      expression =
        compile node.expression

      "let #{node.name.value} = #{expression}"
    end
  end
end
