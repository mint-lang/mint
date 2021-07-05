module Mint
  class Compiler
    def _compile(node : Ast::RecordUpdate) : Codegen::Node
      expression =
        compile node.expression

      fields =
        node.fields
          .map { |item| resolve(item) }
          .reduce({} of Codegen::Node => Codegen::Node) { |memo, item| memo.merge(item) }

      Codegen.join ["_u(", expression, ", ", js.object(fields), ")"]
    end
  end
end
