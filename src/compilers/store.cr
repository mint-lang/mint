module Mint
  class Compiler
    def compile(node : Ast::Store) : String
      functions =
        compile node.functions

      properties =
        compile node.properties

      constructor =
        compile_constructor node

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
        ([constructor] + properties + [state_get] + functions)
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
      properties =
        node.properties.map do |property|
          name =
            property.name.value

          default =
            compile property.default

          "#{name}: #{default}"
        end

      <<-RESULT
      constructor() {
        super()
        this.props = {
          #{properties.join(",").indent}
        }
      }
      RESULT
    end
  end
end
