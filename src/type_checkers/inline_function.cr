module Mint
  class TypeChecker
    type_error InlineFunctionTypeMismatch

    def static_type_signature(node : Ast::InlineFunction) : Checkable
      arguments =
        node.arguments.map { |argument| resolve argument.type }

      return_type =
        node.type.try { |type| resolve type } || Variable.new("a")

      defined_type =
        Type.new("Function", arguments + [return_type])

      Comparer.normalize(defined_type)
    end

    def check(node : Ast::InlineFunction) : Checkable
      scope node do
        body_type =
          resolve node.body

        arguments =
          resolve node.arguments

        final_type =
          Type.new("Function", arguments + [body_type])
        if type = node.type
          return_type =
            resolve type

          defined_type =
            Comparer.normalize(Type.new("Function", arguments + [return_type]))

          resolved =
            Comparer.compare(defined_type, final_type)

          raise InlineFunctionTypeMismatch, {
            "expected" => return_type,
            "got"      => body_type,
            "node"     => node,
          } unless resolved

          Comparer.normalize(defined_type)
        else
          Comparer.normalize(final_type)
        end
      end
    end
  end
end
