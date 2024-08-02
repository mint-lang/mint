module Mint
  class Compiler
    def compile(node : Ast::Map) : Compiled
      compile node do
        fields =
          compile node.fields

        js.array(fields)
      end
    end
  end
end
