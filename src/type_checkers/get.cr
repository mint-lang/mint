module Mint
  class TypeChecker
    type_error GetTypeMismatch

    def static_type_signature(node : Ast::Get) : Checkable
      resolve node.type
    end

    def check(node : Ast::Get) : Checkable
      scope node.where.try(&.statements) || [] of Ast::WhereStatement do
        body_type =
          resolve node.body

        return_type =
          resolve node.type

        node.where.try { |item| resolve item }

        resolved =
          Comparer.compare(body_type, return_type)

        raise GetTypeMismatch, {
          "expected" => return_type,
          "got"      => body_type,
          "node"     => node,
        } unless resolved

        resolved
      end
    end
  end
end
