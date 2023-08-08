module Mint
  class Compiler
    def _compile(node : Ast::For) : String
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
          <<-JS
          const _2 = #{compile(item)}
          if (!_2) { continue }
          JS
        end

      index =
        if index_arg
          "const #{js.variable_of(index_arg)} = _i"
        end

      contents =
        if condition
          ["_i++", index, condition, "_0.push(#{body})"]
        else
          ["_i++", index, "_0.push(#{body})"]
        end

      js.iif do
        js.statements([
          "const _0 = []",
          "const _1 = #{subject}",
          "let _i = -1",
          js.for("let #{arguments} of _1", js.statements(contents.compact)),
          js.return("_0"),
        ])
      end
    end
  end
end
