module Mint
  class Compiler
    def _compile(node : Ast::AccessCall) : String
      access =
        compile node.access

      arguments =
        compile node.arguments

      js.call(access, arguments)
    end
  end
end
