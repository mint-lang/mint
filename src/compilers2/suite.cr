module Mint
  class Compiler2
    def compile(node : Ast::Suite) : Compiled
      compile node do
        location =
          [Raw.new(node.location.to_json)]

        constants =
          resolve node.constants

        functions =
          resolve node.functions

        tests =
          compile node.tests

        name =
          compile node.name

        add(functions + constants)

        js.object({
          "tests"    => js.array(tests),
          "location" => location,
          "name"     => name,
        })
      end
    end
  end
end
