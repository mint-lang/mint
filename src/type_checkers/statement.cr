module Mint
  class TypeChecker
    type_error StatementTupleMismatch
    type_error StatementNotTuple

    def check(node : Ast::Statement | Ast::WhereStatement) : Checkable
      type = resolve node.expression

      case target = node.target
      when Ast::TupleDestructuring
        if target.parameters.size > 1
          raise StatementNotTuple, {
            "node" => node.expression,
            "got"  => type,
          } unless type.name == "Tuple"

          raise StatementTupleMismatch, {
            "parameters" => type.parameters.size.to_s,
            "variables"  => target.parameters.size.to_s,
            "node"       => node.expression,
            "got"        => type,
          } if type.parameters.size < target.parameters.size
        end
      end

      types[node] = type
    end
  end
end
