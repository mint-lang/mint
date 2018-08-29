module Mint
  class TypeChecker
    # type_error ParallelCatchesNothing
    # type_error ParallelDidNotCatch

    def check(node : Ast::Parallel) : Checkable
      to_catch = [] of Checkable

      scope_items =
        node.statements.map do |statement|
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
            {maybe_name.value, type}.as(Tuple(String, Checkable))
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

        raise SequenceCatchesNothing, {
          "got"  => catch_type,
          "node" => catch,
        } if to_catch.none? { |item| Comparer.compare(catch_type, item) }

        scope({catch.variable.value, catch_type}) do
          catch_return_type = resolve catch

          if final_type
            raise SequenceCatchTypeMismatch, {
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

      raise SequenceDidNotCatch, {
        "remaining" => to_catch,
        "node"      => node,
      } if to_catch.any?

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
