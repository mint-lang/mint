module Mint
  class TypeChecker
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

    def check(node : Ast::Function) : Checkable
      scope node do
        scope node.where.try(&.statements) || [] of Ast::WhereStatement do
          node.arguments.each do |argument|
            name =
              argument.name.value

            other =
              (node.arguments - [argument]).find(&.name.value.==(name))

            raise FunctionArgumentConflict, {
              "node"  => argument,
              "other" => other,
              "name"  => name,
            } if other
          end

          node.where.try { |item| resolve item }

          arguments =
            resolve node.arguments

          body_type =
            resolve node.body

          final_type =
            Type.new("Function", arguments + [body_type])

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
        end
      end
    end
  end
end
