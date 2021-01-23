module Mint
  class TypeChecker
    type_error ArrayAccessIndexNotNumber
    type_error ArrayAccessInvalidTuple
    type_error ArrayAccessNotAnArray

    def check(node : Ast::ArrayAccess) : Checkable
      index =
        node.index

      lhs =
        node.lhs

      type =
        resolve lhs

      case index
      when Ast::Expression
        index_type =
          resolve index

        raise ArrayAccessIndexNotNumber, {
          "got"      => index_type,
          "expected" => NUMBER,
          "node"     => index,
        } unless Comparer.compare(index_type, NUMBER)

        check_array_access(lhs, type)
      when Int64
        if type.name == "Tuple"
          parameter =
            type.parameters[index]?

          raise ArrayAccessInvalidTuple, {
            "size"  => type.parameters.size.to_s,
            "index" => ordinal(index),
            "got"   => type,
            "node"  => lhs,
          } unless parameter

          parameter
        else
          check_array_access(lhs, type)
        end
      else
        raise TypeError # Cannot happen!
      end
    end

    def check_array_access(lhs, type)
      raise ArrayAccessNotAnArray, {
        "expected" => ARRAY,
        "got"      => type,
        "node"     => lhs,
      } unless resolved = Comparer.compare(type, ARRAY)

      Type.new("Maybe", [resolved.parameters.first] of Checkable)
    end
  end
end
