module Mint
  class Compiler
    def _compile(node : Ast::Access) : String
      first =
        compile node.lhs

      case cache[node.lhs]
      when TypeChecker::Type
        item =
          lookups[node.field]

        module_name =
          js.class_of(item)

        function_name =
          js.variable_of(item.as(Ast::Module).functions.find(&.name.value.==(node.field.value)).not_nil!)

        "_x(#{first}, #{module_name}.#{function_name})"
      else
        field =
          if record_field_lookup[node.field]?
            node.field.value
          else
            js.variable_of(lookups[node.field])
          end

        "#{first}.#{field}"
      end
    end
  end
end
