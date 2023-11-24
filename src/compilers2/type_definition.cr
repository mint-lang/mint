module Mint
  class Compiler2
    def compile(node : Ast::TypeDefinition) : Compiled
      compile node do
        case type = cache[node]?
        when TypeChecker::Record
          [] of Item
        else
          variants =
            case fields = node.fields
            when Array(Ast::TypeVariant)
              fields.map do |option|
                args =
                  if (fields = option.fields) && option.parameters.any?
                    [js.array(fields.map { |item| [%("#{item.key.value}")] of Item })]
                  else
                    [[option.parameters.size.to_s] of Item]
                  end

                js.const(option, js.call(Builtin::Variant, args))
                # name =
                #   js.class_of(option)

                # mapping =
                #   {} of String => String

                # ids =
                #
                #     fields.map_with_index do |field, index|
                #       mapping[field.key.value] = "\"_#{index}\""

                #       "_#{index}"
                #     end
                #   else
                #     (1..option.parameters.size).map { |index| "_#{index - 1}" }
                #   end

                # assignments =
                #   ids.map { |id| "this.#{id} = #{id}" }

                # js.class(
                #   name,
                #   extends: "_E",
                #   body: [js.function("constructor", ids) do
                #     js.statements([
                #       js.call("super", %w[]),
                #       assignments,
                #       "this.length = #{ids.size}",
                #       mapping.empty? ? nil : "this._mapping = #{js.object(mapping)}",
                #     ].compact.flatten)
                #   end])
              end
            else
              [] of Compiled
            end

          @compiled << js.statements(variants)

          [] of Item
        end
      end
    end
  end
end
