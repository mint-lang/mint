module Mint
  class TypeChecker
    type_error InlineFunctionTypeMismatch

    def check(node : Ast::InlineFunction) : Checkable
      scope node do
        body_type =
          resolve node.body

        return_type =
          resolve node.type

        arguments =
          resolve node.arguments

        defined_type =
          Type.new("Function", arguments + [return_type])

        final_typed =
          Type.new("Function", arguments + [body_type])

        resolved =
          Comparer.compare(defined_type, final_typed)

        raise InlineFunctionTypeMismatch, {
          "expected" => return_type,
          "got"      => body_type,
          "node"     => node,
        } unless resolved

        Comparer.normalize(defined_type)
      end
    end
  end
end
