module Mint
  class TypeChecker
    type_error ParallelCatchTypeMismatch
    type_error ParallelCatchesNothing
    type_error ParallelDidNotCatch
    type_error ParallelCatchedAll

    def check(node : Ast::Parallel) : Checkable
      to_catch = [] of Checkable

      scope_items =
        node.statements.map do |statement|
          check_variable statement.name

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

          maybe_name = statement.name

          if maybe_name
            {maybe_name.value, type, statement}.as(Tuple(String, Checkable, Ast::Node))
          end
        end.compact

      final_type =
        node.then_branch.try do |branch|
          scope(scope_items) do
            resolve branch.expression
          end
        end

      node.catches.each do |catch|
        catch_type = resolve_type(Type.new(catch.type))

        raise ParallelCatchesNothing, {
          "got"  => catch_type,
          "node" => catch,
        } if to_catch.none? { |item| Comparer.compare(catch_type, item) }

        check_variable catch.variable

        scope({catch.variable.value, catch_type, catch}) do
          catch_return_type = resolve catch

          if final_type
            raise ParallelCatchTypeMismatch, {
              "expected" => final_type,
              "got"      => catch_return_type,
              "node"     => catch.expression,
            } unless Comparer.compare(final_type, catch_return_type)
          end
        end

        to_catch.reject! { |item|
          Comparer.compare(catch_type, item)
        }
      end

      resolve node.finally.not_nil! if node.finally

      catch_all_type =
        node.catch_all.try do |catch|
          raise ParallelCatchedAll, {
            "node" => catch,
          } if to_catch.empty?

          type = resolve catch.expression

          if final_type
            raise ParallelCatchTypeMismatch, {
              "expected" => final_type,
              "node"     => catch,
              "got"      => type,
            } unless Comparer.compare(type, final_type)
          end

          type
        end

      raise ParallelDidNotCatch, {
        "remaining" => to_catch,
        "node"      => node,
      } if to_catch.any? && catch_all_type.nil?

      promise_type =
        Type.new("Promise", [NEVER, Variable.new("a")] of Checkable)

      if final_type && Comparer.compare(promise_type, final_type)
        final_type
      else
        Type.new("Promise", [NEVER, final_type || VOID] of Checkable)
      end
    end
  end
end
