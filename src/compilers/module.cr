module Mint
  class Compiler
    def _compile(node : Ast::Module) : Codegen::Node
      name =
        js.class_of(node)

      functions =
        compile node.functions

      constants =
        compile_constants node.constants

      constructor =
        if constants.empty?
          [] of Codegen::Node
        else
          [js.function("constructor", [] of Codegen::Node) do
            js.statements([
              js.call("super", [] of Codegen::Node),
              js.call("this._d", [js.object(constants)]),
            ])
          end]
        end

      js.module(name,
        ([] of Codegen::Node &+ functions &+ constructor)
          .reject! { |item| Codegen.empty?(item) })
    end
  end
end
