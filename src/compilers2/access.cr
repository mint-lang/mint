module Mint
  class Compiler2
    def compile(node : Ast::Access) : Compiled
      compile node do
        if items = variables[node]?
          case items[0]
          when Ast::TypeVariant
            case type = cache[node]?
            when nil
              [] of Item
            else
              if type.name == "Function"
                js.call(Builtin::NewVariant, [[items[0]] of Item] of Compiled)
              else
                js.new(items[0], [] of Compiled)
              end
            end
          else
            # `subscriptions` is a special case: both the parent and the entity
            # is the provider.
            case parent = items[1]
            when Ast::Provider
              case items[0]
              when Ast::Provider
                return [Signal.new(parent.subscription)] of Item
              end
            end

            case item = items[0]
            when Ast::State, Ast::Get
              [Signal.new(item)] of Item
            else
              [item] of Item
            end
          end
        else
          field =
            if record_field_lookup[node.field]?
              node.field.value
            else
              lookups[node.field][0]
            end

          compile(node.expression) + [".", field]
        end
      end
    end
  end
end
