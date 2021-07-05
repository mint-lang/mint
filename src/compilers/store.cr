module Mint
  class Compiler
    def _compile(node : Ast::Store) : Codegen::Node
      functions =
        compile node.functions

      states =
        compile node.states

      gets =
        compile node.gets

      constructor =
        compile_constructor node

      body =
        ([constructor.as(Codegen::Node)] &+ states &+ gets &+ functions)
          .reject! { |item| Codegen.empty?(item) }

      name =
        js.class_of(node)

      js.store(name, body)
    end

    def compile_constructor(node : Ast::Store | Ast::Provider) : Codegen::Node
      states =
        node
          .states
          .select(&.in?(checked))
          .each_with_object({} of Codegen::Node => Codegen::Node) do |state, memo|
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

      js.function("constructor", [] of Codegen::Node) do
        js.statements([
          js.call("super", [] of Codegen::Node),
          js.assign("this.state", js.object(states)),
          constants,
        ].compact)
      end
    end
  end
end
