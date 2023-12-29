module Mint
  class Compiler2
    def compile(node : Ast::Suite) : Compiled
      name =
        compile node.name

      location =
        [Raw.new(node.location.to_json)]

      tests =
        compile node.tests

      constants =
        resolve node.constants

      functions =
        resolve node.functions

      add(functions + constants)

      js.object({
        "tests"    => js.array(tests),
        "location" => location,
        "name"     => name,
      })
    end
  end
end
