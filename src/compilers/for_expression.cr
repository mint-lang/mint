module Mint
  class Compiler
    def _compile(node : Ast::For) : String
      body =
        compile node.body

      subject =
        compile node.subject

      arguments =
        if node.arguments.size == 1
          node.arguments[0].value
        else
          "[" + node.arguments.map(&.value).join(",") + "]"
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
          "#{condition}\n_0.push(#{body})"
        else
          "_0.push(#{body})"
        end

      <<-JS
      (() => {
        const _0 = []
        const _1 = #{subject}

        for (let #{arguments} of _1) {
          #{contents}
        }

        return _0
      })()
      JS
    end
  end
end
