module Mint
  class TypeChecker
    type_error StatementTupleMismatch
    type_error StatementNotTuple

    def check(node : Ast::Statement) : Checkable
      type =
        resolve node.expression

      type =
        type.parameters.first if node.await && type.name == "Promise"

      _check_statement_target(node.target, node, type)

      types[node] = type
    end

    private def _check_statement_target(target : Ast::TupleDestructuring, node, condition)
      raise StatementNotTuple, {
        "node" => node.expression,
        "got"  => condition,
      } unless condition.name == "Tuple"

      raise StatementTupleMismatch, {
        "parameters" => condition.parameters.size.to_s,
        "variables"  => target.parameters.size.to_s,
        "node"       => node.expression,
        "got"        => condition,
      } if target.parameters.size > condition.parameters.size

      target.parameters.each_with_index do |param, index|
        subcondition = condition.parameters[index]
        _check_statement_target(param, node, subcondition)
      end
    end

    private def _check_statement_target(target, node, condition)
    end
  end
end
