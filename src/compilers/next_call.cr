module Mint
  class Compiler
    def _compile(node : Ast::NextCall) : String
      state =
        node
          .data
          .fields
          .map { |item| "#{item.key.value}: #{compile item.value}" }
          .join(",\n")

      "new Promise((_resolve) => {\n" \
      "  this.setState(_update(this.state, new Record({\n#{state}\n})), _resolve)\n" \
      "})"
    end
  end
end
