module Mint
  class TypeChecker
    type_error FunctionArgumentConflict
    type_error FunctionTypeMismatch

    def check(node : Ast::Function) : Checkable
      scope node do
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

        arguments =
          resolve node.arguments

        body_type =
          resolve node.body

        return_type =
          resolve node.type

        node.where.try { |item| resolve item }

        defined_type =
          Type.new("Function", arguments + [return_type])

        final_typed =
          Type.new("Function", arguments + [body_type])

        resolved =
          Comparer.compare(defined_type, final_typed)

        raise FunctionTypeMismatch, {
          "expected" => return_type,
          "got"      => body_type,
          "node"     => node,
        } unless resolved

        Comparer.normalize(defined_type)
      end
    end
  end
end
