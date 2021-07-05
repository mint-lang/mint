module Mint
  class Compiler
    def _compile(node : Ast::For) : Codegen::Node
      subject_type =
        cache[node.subject]

      body =
        compile node.body

      subject =
        compile node.subject

      arguments, index_arg =
        if (subject_type.name == "Array" && node.arguments.size == 1) ||
           (subject_type.name == "Set" && node.arguments.size == 1) ||
           (subject_type.name == "Map" && node.arguments.size == 2)
          if node.arguments.size == 1
            {js.variable_of(node.arguments[0]), nil}
          else
            {js.array(node.arguments.map { |arg| js.variable_of(arg) }), nil}
          end
        else
          if node.arguments.size == 2
            {js.variable_of(node.arguments[0]), node.arguments[1]}
          else
            {
              js.array(node.arguments[0..1].map { |arg| js.variable_of(arg) }),
              node.arguments[2],
            }
          end
        end

      condition =
        node.condition.try do |item|
          Codegen.join [
            "const _2 = ", compile(item.condition),
            "\nif (!_2) { continue }",
          ]
        end

      index =
        if index_arg
          Codegen.join(["const ", js.variable_of(index_arg), " = _i"])
        end

      contents =
        if condition
          [condition, index, Codegen.join(["_0.push(", body, ")"]), "_i++"].compact
        else
          [index, Codegen.join(["_0.push(", body, ")"]), "_i++"].compact
        end

      js.iif do
        js.statements([
          "const _0 = []",
          Codegen.join(["const _1 = ", subject]),
          "let _i = 0",
          js.for(Codegen.join(["let ", arguments, " of _1"]), js.statements(contents)),
          js.return("_0"),
        ])
      end
    end
  end
end
