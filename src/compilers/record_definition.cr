module Mint
  class Compiler
    def _compile(node : Ast::RecordDefinition) : String
      type = types[node]

      name =
        underscorize type.name

      case type
      when TypeChecker::Record
        mappings =
          type.mappings.to_json

        decoder =
          begin
            @decoder.compile type
          rescue
            "() => { console.warn('Cannot decode this record!') }"
          end

        <<-JS
        class $$#{name} extends Record {}

        $$#{name}.mappings = #{mappings}

        $$#{name}.decode = #{decoder}
        JS
      else
        ""
      end
    end
  end
end
