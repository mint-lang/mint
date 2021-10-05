module Mint
  class Compiler
    def compile(node : Ast::Function, contents = "") : String
      if checked.includes?(node)
        _compile node, contents
      else
        ""
      end
    end

    def _compile(node : Ast::Function, contents = "") : String
      name =
        js.variable_of(node)

      expression =
        case item = node.body
        when Ast::Block
          compile item, for_function: true
        else
          compile item
        end

      arguments =
        compile node.arguments

      items =
        [expression]

      items.unshift(contents) unless contents.empty?

      body =
        js.statements(items)

      js.function(name, arguments, body)
    end
  end
end
