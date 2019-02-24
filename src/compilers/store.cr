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

    def compile_constructor(node : Ast::Store) : String
      states =
        node
          .states
          .select { |state| checked.includes?(state) }
          .each_with_object({} of String => String) do |state, memo|
            name =
              js.variable_of(state)

            default =
              compile state.default

            memo[name] = default
          end

      js.function("constructor", [] of String) do
        js.statements([
          js.call("super", [] of String),
          js.assign("this.state", js.object(states)),
        ])
      end
    end
  end
end
