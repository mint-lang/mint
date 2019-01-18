module Mint
  class Compiler
    def _compile(node : Ast::Module) : String
      body =
        compile node.functions, "\n\n"

      name =
        underscorize node.name

      binds =
        node
          .functions
          .select { |item| checked.includes?(item) }
          .map { |item| "this.#{item.name.value} = this.#{item.name.value}.bind(this)" }
          .join("\n")

      <<-A
      const $#{name} = new(class {
        constructor() {
        #{binds.indent}
        }

      #{body.indent}
      })
      A
    end
  end
end
