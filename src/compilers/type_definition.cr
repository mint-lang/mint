module Mint
  class Compiler
    def _compile(node : Ast::TypeDefinition) : String
      case type = cache[node]?
      when TypeChecker::Record
        name =
          js.class_of(type.name)

        mappings =
          begin
            @serializer.generate_mappings type
          rescue
            "{}"
          end

        "const #{name} = _R(#{mappings})"
      else
        variants =
          case fields = node.fields
          when Array(Ast::TypeVariant)
            fields.map do |option|
              name =
                js.class_of(option)

              mapping =
                {} of String => String

              ids =
                if fields = option.fields
                  fields.map_with_index do |field, index|
                    mapping[field.key.value] = "\"_#{index}\""

                    "_#{index}"
                  end
                else
                  (1..option.parameters.size).map { |index| "_#{index - 1}" }
                end

              assignments =
                ids.map { |id| "this.#{id} = #{id}" }

              js.class(
                name,
                extends: "_E",
                body: [js.function("constructor", ids) do
                  js.statements([
                    js.call("super", %w[]),
                    assignments,
                    "this.length = #{ids.size}",
                    mapping.empty? ? nil : "this._mapping = #{js.object(mapping)}",
                  ].compact.flatten)
                end])
            end
          else
            [] of String
          end

        js.statements(variants)
      end
    end
  end
end
