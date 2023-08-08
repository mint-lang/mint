module Mint
  class Compiler
    def _compile(node : Ast::Field)
      compile node.value
    end

    def resolve(node : Ast::Field) : Hash(String, String)
      return {} of String => String unless key = node.key

      value =
        compile node.value

      name =
        key.value

      {name => value}
    end
  end
end
