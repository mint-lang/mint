module Mint
  class Compiler
    def _compile(node : Ast::RecordDefinition) : String
      type = types[node]

      name =
        js.class_of(type.name)

      case type
      when TypeChecker::Record
        mappings =
          js.object(
            type.mappings.each_with_object({} of String => String) do |(key, value), memo|
              field =
                js.variable_of(type.name, key)

              memo[field] = value ? %("#{value}") : %("#{key}")
            end)

        decoder =
          begin
            @decoder.compile type
          rescue
            js.arrow_function([] of String) do
              "console.warn('Cannot decode this record!')"
            end
          end

        <<-JS
        class #{name} extends Record {}

        #{name}.mappings = #{mappings}

        #{name}.decode = #{decoder}
        JS
      else
        ""
      end
    end
  end
end
