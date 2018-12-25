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
        ([constructor] + states + gets + functions)
          .join("\n\n")
          .indent

      name =
        underscorize node.name

      <<-RESULT
      const $#{name} = new (class extends Store {
        #{body}
      })
      $#{name}.__displayName = `#{node.name}`
      RESULT
    end

    def compile_constructor(node : Ast::Store) : String
      states =
        node.states.map do |state|
          name =
            state.name.value

          default =
            compile state.default

          "#{name}: #{default}"
        end

      <<-RESULT
      constructor() {
        super()
        this.state = {
          #{states.join(",\n").indent}
        }
      }
      RESULT
    end
  end
end
