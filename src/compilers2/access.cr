module Mint
  class Compiler2
    def compile(node : Ast::Access) : Compiled
      compile node do
        if items = variables[node]?
          case items[0]
          when Ast::TypeVariant
            type =
              cache[node]?

            case type
            when nil
              [] of Item
            else
              if type.name == "Function"
                js.call(Builtin::NewVariant, [[items[0]] of Item] of Compiled)
              else
                ["new", " ", items[0], "()"] of Item
              end
            end
          else
            case parent = items[1]
            when Ast::Provider
              if node.field.value == "subscriptions"
                return [Signal.new(parent.subscription)] of Item
              end
            end

            item =
              items[0].as(Ast::Node)

            case items[0]
            when Ast::Get,
                 Ast::State
              [Signal.new(item)] of Item
            else
              [item] of Item
            end
          end
        else
          first =
            compile node.expression

          field =
            if record_field_lookup[node.field]?
              node.field.value
            else
              lookups[node.field][0]
            end

          first + [".", field]
        end
      end
    end
  end
end
