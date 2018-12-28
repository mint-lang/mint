module Mint
  class TypeChecker
    type_error TryCatchTypeMismatch
    type_error TryCatchesNothing
    type_error TryDidNotCatch
    type_error TryCatchedAll

    def check(node : Ast::Try) : Checkable
      to_catch = [] of Checkable

      # Resolve the types of the statements
      types =
        node
          .statements
          .reduce([] of Tuple(String, Checkable, Ast::Node)) do |items, statement|
            name =
              statement.name.try(&.value).to_s

            # Scope based on the previous statements
            scope(items) do
              new_type = resolve statement

              # If the statement has a name and it's a result
              type =
                if statement.name &&
                   new_type.name == "Result" &&
                   new_type.parameters.size == 2
                  # If the error is not Never then that type needs to be catched
                  if new_type.parameters[0].name != "Never"
                    to_catch << new_type.parameters[0]
                  end
                  new_type.parameters[1]
                end

              # Append the type
              items << {name, resolve_type(type || new_type), statement}
            end

            # Return the memo
            items
          end

      # Start reducing the catches using the last type
      final_type = node.catches.reduce(types.last[1]) do |type, catch|
        catch_type = resolve_type(Type.new(catch.type))

        # If the type does not need to be catched
        raise TryCatchesNothing, {
          "got"  => catch_type,
          "node" => catch,
        } if to_catch.none? { |item| Comparer.compare(catch_type, item) }

        check_variable catch.variable

        checked_type = scope({catch.variable.value, catch_type, catch}) do
          return_type =
            resolve catch

          result_type =
            Comparer.compare(return_type, type)

          # If the type does not match catch
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

      catch_all_type =
        node.catch_all.try do |catch|
          raise TryCatchedAll, {
            "node" => catch,
          } if to_catch.empty?

          type = resolve catch.expression

          raise TryCatchTypeMismatch, {
            "expected" => final_type,
            "node"     => catch,
            "got"      => type,
          } unless Comparer.compare(type, final_type)

          type
        end

      raise TryDidNotCatch, {
        "remaining" => to_catch.uniq(&.to_s),
        "node"      => node,
      } if to_catch.any? && catch_all_type.nil?

      final_type
    end
  end
end
