module Mint
  class Compiler
    def compile(node : Ast::Function, contents : Codegen::Node = "") : Codegen::Node
      if checked.includes?(node)
        _compile node, contents
      else
        ""
      end
    end

    def _compile(node : Ast::Function, contents : Codegen::Node = "") : Codegen::Node
      name =
        Codegen.source_mapped(node.name, js.variable_of(node))

      expression =
        compile node.body

      wheres =
        (node.where
          .try(&.statements)
          .try(&.sort_by { |item| resolve_order.index(item) || -1 })
          .try { |statements| compile statements } || [] of Codegen::Node)
          .reject! { |item| Codegen.empty?(item) }

      arguments =
        node.arguments.map { |arg| Codegen.source_mapped(arg, compile arg) }

      last =
        [Codegen.source_mapped(node.body, js.return(expression)).as(Codegen::Node)]

      last.unshift(contents) unless Codegen.empty? contents

      body =
        Codegen.source_mapped(node.where || node.body, js.statements(wheres + last))

      js.function(name, arguments, body)
    end
  end
end
