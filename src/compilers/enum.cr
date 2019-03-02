module Mint
  class Compiler
    def _compile(node : Ast::Enum) : String
      node.options.map do |option|
        name =
          js.class_of(option)

        ids =
          (1..option.parameters.size)
            .map { |index| "_#{index - 1}" }

        assignments =
          ids.map { |item| "this.#{item} = #{item}" }

        js.class(
          name,
          extends: "Enum",
          body: [js.function("constructor", ids) do
                   js.statements([
                     js.call("super", [] of String),
                     assignments,
                     "this.length = #{option.parameters.size}",
                   ].flatten)
                 end])
      end.join("\n")
    end
  end
end
