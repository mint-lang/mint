class TypeChecker
  type_error TryCatchTypeMismatch
  type_error TryCatchesNothing
  type_error TryDidNotCatch

  def check(node : Ast::Try) : Type
    to_catch = [] of Type

    types =
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
          new_type = check statement

          type =
            if statement.name &&
               new_type.name == "Result" &&
               new_type.parameters.size == 2
              if new_type.parameters[0].name != "Never"
                to_catch << new_type.parameters[0]
              end
              new_type.parameters[1]
            end

          items << {name, resolve_type(type || new_type)}
        end

        items
      end

    final_type = node.catches.reduce(types.last[1]) do |type, catch|
      catch_type = resolve_type(Type.new(catch.type))

      raise TryCatchesNothing, {
        "got"  => catch_type,
        "node" => catch,
      } if to_catch.none? { |item| Comparer.compare(catch_type, item) }

      checked_type = scope({catch.variable.value, catch_type}) do
        return_type = check catch
        result_type = Comparer.compare(return_type, type)

        raise TryCatchTypeMismatch, {
          "got"      => return_type,
          "node"     => catch,
          "expected" => type,
        } unless result_type

        result_type
      end

      to_catch
        .reject! { |item| Comparer.compare(catch_type, item) }

      checked_type
    end

    raise TryDidNotCatch, {
      "remaining" => to_catch.uniq(&.to_s),
      "node"      => node,
    } if to_catch.any?

    final_type
  end
end
