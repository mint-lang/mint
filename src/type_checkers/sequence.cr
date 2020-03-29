module Mint
  class TypeChecker
    type_error SequenceCatchTypeMismatch
    type_error SequenceCatchesNothing
    type_error SequenceDidNotCatch
    type_error SequenceCatchedAll

    def check(node : Ast::Sequence) : Checkable
      to_catch = [] of Checkable

      scope node.statements do
        node.statements.map do |statement|
          new_type = resolve statement

          if new_type.name.in?("Promise", "Result") && new_type.parameters.size == 2
            unless new_type.parameters[0].name.in?("Void", "Never")
              to_catch << new_type.parameters[0]
            end
          end
        end
      end

      final_type = resolve node.statements.last

      node.catches.each do |catch|
        catch_type = resolve_type(Type.new(catch.type))

        raise SequenceCatchesNothing, {
          "got"  => catch_type,
          "node" => catch,
        } if to_catch.none? { |item| Comparer.compare(catch_type, item) }

        check_variable catch.variable

        scope({catch.variable.value, catch_type, catch}) do
          catch_return_type = resolve catch

          raise SequenceCatchTypeMismatch, {
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

      catch_all_type =
        node.catch_all.try do |catch|
          raise SequenceCatchedAll, {
            "node" => catch,
          } if to_catch.empty?

          type = resolve catch.expression

          raise SequenceCatchTypeMismatch, {
            "expected" => final_type,
            "node"     => catch,
            "got"      => type,
          } unless Comparer.compare(type, final_type)

          type
        end

      raise SequenceDidNotCatch, {
        "remaining" => to_catch,
        "node"      => node,
      } if !to_catch.empty? && catch_all_type.nil?

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
