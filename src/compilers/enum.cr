module Mint
  class Compiler
    def compile(node : Ast::Enum) : String
      prefix =
        underscorize node.name

      node.options.map do |option|
        name =
          underscorize option.value

        full_name =
          prefix + "_" + name

        if option.parameters.any?
          ids =
            (1..option.parameters.size)
              .map { |index| "_#{index - 1}" }

          arguments =
            ids.join(", ")

          assignments =
            ids
              .map { |item| "this.#{item} = #{item}" }
              .join("\n")

          <<-JS
          class $$#{full_name} {
            constructor(#{arguments}) {
              #{assignments}
            }
          };
          JS
        else
          "class $$#{full_name} {}"
        end
      end.join("\n")
    end
  end
end
