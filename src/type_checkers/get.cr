module Mint
  class TypeChecker
    type_error GetTypeMismatch

    def static_type_signature(node : Ast::Get) : Checkable
      node.type.try { |type| resolve type } || Variable.new("a")
    end

    def check(node : Ast::Get) : Checkable
      scope node.where.try(&.statements) || [] of Ast::WhereStatement do
        body_type =
          resolve node.body

        if type = node.type
          return_type =
            resolve type

          node.where.try { |item| resolve item }

          resolved =
            Comparer.compare(body_type, return_type)

          raise GetTypeMismatch, {
            "expected" => return_type,
            "got"      => body_type,
            "node"     => node,
          } unless resolved

          resolved
        else
          body_type
        end
      end
    end
  end
end
