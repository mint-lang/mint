module Mint
  class Compiler
    def compile(node : Ast::State) : String
      data =
        compile node.data

      "this.state = #{data}"
    end
  end
end
