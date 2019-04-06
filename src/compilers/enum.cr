module Mint
  class Compiler
    def _compile(node : Ast::Enum) : String
      enum_ids =
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
            extends: "_E",
            body: [js.function("constructor", ids) do
                     js.statements([
                       js.call("super", [] of String),
                       assignments,
                       "this.length = #{option.parameters.size}",
                     ].flatten)
                   end])
        end

      js.statements(enum_ids)
    end
  end
end
