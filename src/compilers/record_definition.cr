module Mint
  class Compiler
    def _compile(node : Ast::RecordDefinition) : String
      type = types[node]

      name =
        js.class_of(type.name)

      case type
      when TypeChecker::Record
        mappings =
          begin
            @serializer.generate_mappings type
          rescue
            "{}"
          end

        "const #{name} = _R(#{mappings})"
      else
        ""
      end
    end
  end
end
