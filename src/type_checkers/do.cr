module Mint
  class TypeChecker
    type_error DoCatchTypeMismatch
    type_error DoCatchesNothing
    type_error DoDidNotCatch

    def check(node : Ast::Do) : Checkable
      to_catch = [] of Checkable

      checked =
        node
          .statements
          .reduce([] of Tuple(String, Checkable)) do |items, statement|
            maybe_name = statement.name

            name =
              if maybe_name
                maybe_name.value
              else
                ""
              end

            scope(items) do
              new_type = resolve statement

              type =
                if (new_type.name == "Promise" || new_type.name == "Result") &&
                   new_type.parameters.size == 2
                  if new_type.parameters[0].name != "Void" &&
                     new_type.parameters[0].name != "Never"
                    to_catch << new_type.parameters[0]
                  end

                  resolve_type(new_type.parameters[1])
                else
                  resolve_type(new_type)
                end

              items << {name, type}
            end

            items
          end

      final_type = checked.last[1]

      node.catches.each do |catch|
        catch_type = resolve_type(Type.new(catch.type))

        raise DoCatchesNothing, {
          "got"  => catch_type,
          "node" => catch,
        } if to_catch.none? { |item| Comparer.compare(catch_type, item) }

        scope({catch.variable.value, catch_type}) do
          catch_return_type = resolve catch

          raise DoCatchTypeMismatch, {
            "expected" => final_type,
            "got"      => catch_return_type,
            "node"     => catch.expression,
          } unless Comparer.compare(final_type, catch_return_type)
        end

        to_catch.reject! { |item|
          Comparer.compare(catch_type, item)
        }
      end

      resolve node.finally.not_nil! if node.finally

      raise DoDidNotCatch, {
        "remaining" => to_catch,
        "node"      => node,
      } if to_catch.any?

      Type.new("Promise", [NEVER, final_type] of Checkable)
    end
  end
end
