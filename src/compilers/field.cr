module Mint
  class Compiler
    def compile(node : Ast::Field)
      compile node do
        compile node.value
      end
    end

    def resolve(node : Ast::Field) : Hash(Item, Compiled)
      return {} of Item => Compiled unless key = node.key

      value =
        compile node.value

      name =
        key.value

      {name.as(Item) => value}
    end
  end
end
