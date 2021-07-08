module Mint
  class TypeChecker
    type_error FunctionArgumentMustHaveADefaultValue
    type_error FunctionArgumentConflict
    type_error FunctionTypeMismatch
    type_error FunctionTypeNeeded

    def static_type_signature(node : Ast::Function) : Checkable
      arguments =
        node.arguments.map { |argument| resolve argument.type }

      return_type =
        node.type.try { |type| resolve type } || Variable.new("a")

      defined_type =
        Type.new("Function", arguments + [return_type])

      Comparer.normalize(defined_type)
    end

    def check_arguments(arguments : Array(Ast::Argument))
      was_default = false

      arguments.each do |argument|
        name =
          argument.name.value

        other =
          (arguments - [argument]).find(&.name.value.==(name))

        raise FunctionArgumentMustHaveADefaultValue, {
          "node" => argument,
          "name" => name,
        } if was_default && !argument.default

        was_default = true if argument.default

        raise FunctionArgumentConflict, {
          "node"  => argument,
          "other" => other,
          "name"  => name,
        } if other
      end
    end

    def check(node : Ast::Function) : Checkable
      scope node do
        check_arguments(node.arguments)

        arguments =
          resolve node.arguments

        body_type =
          resolve node.body

        final_type =
          Type.new("Function", arguments + [body_type])

        resolved_type =
          if type = node.type
            return_type =
              resolve type

            defined_type =
              Comparer.normalize(Type.new("Function", arguments + [return_type]))

            resolved =
              Comparer.compare(defined_type, final_type)

            raise FunctionTypeMismatch, {
              "expected" => return_type,
              "got"      => body_type,
              "node"     => node,
            } unless resolved

            resolved
          else
            Comparer.normalize(final_type)
          end

        resolved_type.optional_count = node.arguments.count(&.default)
        resolved_type
      end
    end
  end
end
