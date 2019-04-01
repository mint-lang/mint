module Mint
  class Compiler
    def _compile(node : Ast::For) : String
      body =
        compile node.body

      subject =
        compile node.subject

      arguments =
        if node.arguments.size == 1
          js.variable_of(node.arguments[0])
        else
          js.array(node.arguments.map { |arg| js.variable_of(arg) })
        end

      condition =
        node.condition.try do |item|
          <<-JS
          const _2 = #{compile(item.condition)}
          if (!_2) { continue }
          JS
        end

      contents =
        if condition
          js.statements([condition, "_0.push(#{body})"])
        else
          "_0.push(#{body})"
        end

      js.iif do
        js.statements([
          "const _0 = []",
          "const _1 = #{subject}",
          js.for("let #{arguments} of _1", contents),
          js.return("_0"),
        ])
      end
    end
  end
end
