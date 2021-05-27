module Mint
  class Compiler
    def _compile(node : Ast::Suite) : String
      name =
        compile node.name

      location =
        node.location.to_json

      tests =
        compile node.tests, ","

      constants =
        compile_constants node.constants

      "{ name: #{name}, location: #{location}, tests: [#{tests}], constants: #{js.object(constants)} }"
    end
  end
end
