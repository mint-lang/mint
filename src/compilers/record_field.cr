module Mint
  class Compiler
    def resolve(node : Ast::RecordField) : Hash(String, String)
      value =
        compile node.value

      name =
        node.key.value

      {name => value}
    end
  end
end
