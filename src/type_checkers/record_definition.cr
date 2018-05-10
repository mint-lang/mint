module Mint
  class TypeChecker
    def check(node : Ast::RecordDefinition) : Type
      fields =
        node
          .fields
          .map { |field| {field.key.value, check(field).as(Type)} }
          .to_h

      Record.new(node.name, fields)
    end
  end
end
