module Mint
  class Compiler
    def compile(node : Ast::Get) : String
      body =
        compile node.body

      name =
        node.name.value

      body =
        "return #{body}".indent

      "get #{name}() {\n#{body}\n}"
    end
  end
end
