module Mint
  class Compiler
    def _compile(node : Ast::Suite) : String
      name =
        compile node.name

      tests =
        compile node.tests, ","

      constants =
        compile_constants node.constants

      "{ name: #{name}, tests: [#{tests}], constants: #{js.object(constants)} }"
    end
  end
end
