module Mint
  class Compiler
    def _compile(node : Ast::Enum) : String
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
          class $$#{full_name} extends Enum {
            constructor(#{arguments}) {
              super()

              #{assignments}

              this.length = #{option.parameters.size}
            }
          };
          JS
        else
          <<-JS
          class $$#{full_name} extends Enum {
            constructor() {
              super()

              this.length = 0
            }
          };
          JS
        end
      end.join("\n")
    end
  end
end
