module Mint
  class Compiler
    def compile(node : Ast::Suite) : String
      name =
        compile node.name

      tests =
        compile node.tests, ","

      "{ name: #{name}, tests: [#{tests}] }"
    end
  end
end
