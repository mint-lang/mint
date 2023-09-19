module Mint
  class Compiler
    def _compile(node : Ast::Suite) : String
      name =
        compile node.name

      location =
        node.location.to_json

      tests =
        compile node.tests

      constants =
        compile_constants(node.constants).map do |key, value|
          "#{key}: #{value}"
        end

      functions =
        compile node.functions

      context =
        "{ #{(constants + functions).join(",")} }"

      js.object({
        "tests"    => js.array(tests),
        "location" => location,
        "context"  => context,
        "name"     => name,
      })
    end
  end
end
