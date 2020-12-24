module Mint
  class Compiler
    def _compile(node : Ast::Suite) : Codegen::Node
      name =
        (compile node.name).as(Codegen::Node)

      location =
        node.location.to_json

      tests =
        (compile node.tests, ",").as(Codegen::Node)

      constants =
        compile_constants node.constants

      Codegen.join(["{ name: ", name, ", location: ", location, ", tests: [", tests, "], constants: ", js.object(constants), " }"])
    end
  end
end
