module Mint
  class TypeChecker
    type_error VariableReserved
    type_error VariableMissing

    RESERVED =
      %w(break case catch class const continue debugger default delete do else
        export extends finally for function if import in instanceof new return
        super switch this throw try typeof var void while with yield)

    def check(node : Ast::Variable) : Type
      raise VariableReserved, {
        "name" => node.value,
        "node" => node,
      } if RESERVED.includes?(node.value)

      item = loopkup_with_level(node)

      raise VariableMissing, {
        "name" => node.value,
        "node" => node,
      } unless item

      variables[node] = item

      resolve item[0]
    end
  end
end
