module Mint
  class Compiler
    def _compile(node : Ast::Access) : String
      if items = variables[node]?
        case items[0]
        when Ast::TypeVariant
          name =
            js.class_of(items[0])

          type =
            cache[node]?

          case type
          when nil
            ""
          else
            if type.name == "Function"
              "_n(#{name})"
            else
              "new #{name}()"
            end
          end
        else
          name =
            js.class_of(items[1].as(Ast::Node))

          case items[1]
          when Ast::Provider
            if node.field.value == "subscriptions"
              return "#{name}._subscriptions"
            end
          end

          variable =
            js.variable_of(items[0].as(Ast::Node))

          "#{name}.#{variable}"
        end
      else
        first =
          compile node.expression

        field =
          if record_field_lookup[node.field]?
            node.field.value
          else
            js.variable_of(lookups[node.field][0])
          end

        "#{first}.#{field}"
      end
    end
  end
end
