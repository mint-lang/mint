module Mint
  class Compiler
    def _compile(node : Ast::Property) : String
      name =
        node.name.value

      default =
        compile node.default

      body =
        "if (this.props.#{name} != undefined) {\n" \
        "  return this.props.#{name}\n" \
        "} else {\n" \
        "  return #{default}\n" \
        "}"

      "get #{name} () {\n#{body.indent}\n}"
    end
  end
end
