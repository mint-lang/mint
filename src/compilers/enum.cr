module Mint
  class Compiler
    def _compile(node : Ast::Enum) : Codegen::Node
      enum_ids =
        node.options.map do |option|
          name =
            js.class_of(option)

          ids =
            (1..option.parameters.size)
              .map { |index| "_#{index - 1}" }

          assignments =
            ids.map { |item| Codegen.join ["this.", item, " = ", item] }

          js.class(
            name,
            extends: "_E",
            body: [js.function("constructor", ids) do
              js.statements([
                js.call("super", [] of Codegen::Node),
                assignments,
                "this.length = #{option.parameters.size}",
              ].flatten)
            end])
        end

      js.statements(enum_ids)
    end
  end
end
