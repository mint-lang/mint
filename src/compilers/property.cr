module Mint
  class Compiler
    def _compile(node : Ast::Property) : String
      prop_name =
        if node.name.value == "children"
          "children"
        else
          js.variable_of(node)
        end

      name =
        js.variable_of(node)

      body =
        "return '#{prop_name}' in this.props ? this.props.#{prop_name} : this.defaultProps.#{name}"

      js.get(name, body)
    end
  end
end
