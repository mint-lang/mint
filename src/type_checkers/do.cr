module Mint
  class TypeChecker
    type_error DoCatchesNothing
    type_error DoDidNotCatch

    def check(node : Ast::Do) : Type
      to_catch = [] of Type

      node
        .statements
        .reduce([] of Tuple(String, Type)) do |items, statement|
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

      node.catches.each do |catch|
        catch_type = resolve_type(Type.new(catch.type))

        raise DoCatchesNothing, {
          "got"  => catch_type,
          "node" => catch,
        } if to_catch.none? { |item| Comparer.compare(catch_type, item) }

        scope({catch.variable.value, catch_type}) do
          resolve catch
        end

        to_catch.reject! { |item| Comparer.compare(catch_type, item) }
      end

      resolve node.finally.not_nil! if node.finally

      raise DoDidNotCatch, {
        "remaining" => to_catch,
        "node"      => node,
      } if to_catch.any?

      VOID
    end
  end
end
