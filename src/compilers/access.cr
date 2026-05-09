module Mint
  class Compiler
    private def compile_access_item(item)
      case item
      when Ast::Get
        js.call(item, [] of Compiled)
      when Ast::State, Ast::Signal
        [Signal.new(item)] of Item
      else
        [item] of Item
      end
    end

    def compile(node : Ast::Access) : Compiled
      compile node do
        if items = variables[node]?
          case item = items[0]
          when Ast::TypeVariant
            if type = cache[node]?
              if type.name == "Function"
                js.call(Builtin::NewVariant, [tag(item, cache[item])] of Compiled)
              else
                js.new(tag(item, cache[item]), [] of Compiled)
              end
            else
              [] of Item
            end
          else
            # `subscriptions` is a special case: both the parent and the entity
            # is the provider.
            case parent = items[1]
            when Ast::Provider
              case items[0]
              when Ast::Provider
                return js.call(Builtin::Subscriptions, [[parent.subscription] of Item])
              end
            end

            compile_access_item(items[0])
          end
        elsif record_field_lookup[node.field]?
          compile(node.expression) + ["."] + [node.field.value] of Item
        else
          lookup =
            lookups[node.field]

          item =
            case field = lookup[0]
            when Ast::Variable
              [Signal.new(lookup[0])] of Item
            else
              compile_access_item(field)
            end

          compile(node.expression) + ["."] + item
        end
      end
    end
  end
end
