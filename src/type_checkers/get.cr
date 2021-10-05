module Mint
  class TypeChecker
    type_error GetTypeMismatch

    def static_type_signature(node : Ast::Get) : Checkable
      node.type.try { |type| resolve type } || Variable.new("a")
    end

    def check(node : Ast::Get) : Checkable
      body_type =
        resolve node.body

      if type = node.type
        return_type =
          resolve type

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
