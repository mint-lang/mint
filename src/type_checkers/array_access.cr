module Mint
  class TypeChecker
    type_error ArrayAccessIndexNotNumber
    type_error ArrayAccessNotAnArray

    def check(node : Ast::ArrayAccess) : Checkable
      index =
        node.index

      lhs =
        node.lhs

      case index
      when Ast::Expression
        type =
          resolve index

        raise ArrayAccessIndexNotNumber, {
          "expected" => NUMBER,
          "node"     => index,
          "got"      => type,
        } unless Comparer.compare(type, NUMBER)
      end

      type =
        resolve lhs

      raise ArrayAccessNotAnArray, {
        "expected" => ARRAY,
        "got"      => type,
        "node"     => lhs,
      } unless resolved = Comparer.compare(type, ARRAY)

      Type.new("Maybe", [resolved.parameters.first] of Checkable)
    end
  end
end
