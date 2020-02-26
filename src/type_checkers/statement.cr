module Mint
  class TypeChecker
    type_error StatementTupleMismatch
    type_error StatementNotTuple

    def check(node : Ast::Statement | Ast::WhereStatement) : Checkable
      type = resolve node.expression

      if node.variables.size > 1
        raise StatementNotTuple, {
          "node" => node.expression,
          "got"  => type,
        } unless type.name == "Tuple"

        raise StatementTupleMismatch, {
          "parameters" => type.parameters.size.to_s,
          "variables"  => node.variables.size.to_s,
          "node"       => node.expression,
          "got"        => type,
        } if type.parameters.size < node.variables.size
      end

      types[node] = type
    end
  end
end
