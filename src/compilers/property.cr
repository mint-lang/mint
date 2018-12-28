module Mint
  class Compiler
    def _compile(node : Ast::Property) : String
      name =
        js.variable_of(node)

      body =
        "return this.props.#{name} || this.defaultProps.#{name}"

      js.get(name, body)
    end
  end
end
