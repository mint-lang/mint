module Mint
  type_error InlineFunctionTypeMismatch

  class TypeChecker
    def check(node : Ast::InlineFunction) : Checkable
      scope node do
        body_type =
          resolve node.body

        return_type =
          resolve node.type

        arguments =
          resolve node.arguments

        raise InlineFunctionTypeMismatch, {
          "expected" => return_type,
          "got"      => body_type,
          "node"     => node,
        } unless Comparer.compare(body_type, return_type)

        Type.new("Function", arguments + [return_type])
      end
    end
  end
end
