module Mint
  class Compiler
    def _compile(node : Ast::Store) : String
      functions =
        compile node.functions

      states =
        compile node.states

      gets =
        compile node.gets

      constructor =
        compile_constructor node

      body =
        [constructor] + states + gets + functions

      name =
        js.class_of(node)

      js.store(name, body)
    end

    def compile_constructor(node : Ast::Store | Ast::Provider) : String
      states =
        node
          .states
          .select(&.in?(checked))
          .each_with_object({} of String => String) do |state, memo|
            name =
              js.variable_of(state)

            default =
              compile state.default

            memo[name] = default
          end

      constants =
        if !node.constants.empty?
          js.call("this._d", [js.object(compile_constants(node.constants))])
        end

      js.function("constructor", %w[]) do
        js.statements([
          js.call("super", %w[]),
          js.assign("this.state", js.object(states)),
          constants,
        ].compact)
      end
    end
  end
end
