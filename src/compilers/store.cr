module Mint
  class Compiler
    def compile(node : Ast::Store) : String
      functions =
        compile node.functions

      properties =
        compile node.properties

      state_properties =
        node
          .properties
          .map(&.name.value)
          .map { |property| "#{property}: this.#{property}" }
          .join(",\n")

      state =
        "return {\n#{state_properties}\n}"

      state_get =
        "get state () {\n#{state.indent}\n}"

      body =
        (properties + [state_get] + functions)
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
  end
end
