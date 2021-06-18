module Mint
  class Compiler
    def _compile(node : Ast::Module) : String
      name =
        js.class_of(node)

      functions =
        compile node.functions

      constants =
        compile_constants node.constants

      constructor =
        unless constants.empty?
          [js.function("constructor", %w[]) do
            js.statements([
              js.call("super", %w[]),
              js.call("this._d", [js.object(constants)]),
            ])
          end]
        end

      js.module(name, %w[] &+ functions &+ constructor)
    end
  end
end
