module Mint
  class TypeChecker
    type_error TryCatchTypeMismatch
    type_error TryCatchesNothing
    type_error TryDidNotCatch
    type_error TryCaughtAll

    def check(node : Ast::Try) : Checkable
      to_catch = [] of Checkable

      statements = node.statements
      statements_size = statements.size

      # Resolve the types of the statements
      types = scope statements do
        statements.map_with_index do |statement, index|
          new_type = resolve statement

          if index == (statements_size - 1)
            # The last statement is not unwrapped so a Result can be returned directly
            new_type
          else
            # If the statement has a name and it's a Result
            if new_type.name == "Result"
              type =
                case
                when new_type.parameters[0].name[0].ascii_lowercase?
                  # If the error type is a variable it can't be caught
                  # but it is still unwrapped
                  new_type.parameters[1]
                when new_type.parameters.size == 2
                  # If the error is not Never then that type needs to be caught
                  unless new_type.parameters[0].name == "Never"
                    to_catch << new_type.parameters[0]
                  end
                  new_type.parameters[1]
                end
            end

            type || new_type
          end
        end
      end

      # Start reducing the catches using the last type
      final_type = node.catches.reduce(types.last) do |type, catch|
        catch_type = resolve_type(Type.new(catch.type))

        # If the type does not need to be caught
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
          raise TryCaughtAll, {
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
      } if !to_catch.empty? && catch_all_type.nil?

      final_type
    end
  end
end
