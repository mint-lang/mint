module Mint
  class TypeChecker
    type_error GetTypeMismatch

    def check(node : Ast::Get) : Checkable
      scope node do
        body_type =
          resolve node.body

        return_type =
          resolve node.type

        raise GetTypeMismatch, {
          "expected" => return_type,
          "got"      => body_type,
          "node"     => node,
        } unless Comparer.compare(body_type, return_type)

        return_type
      end
    end
  end
end
