module Mint
  class TypeChecker
    type_error PropertyTypeMismatch

    def check(node : Ast::Property, component : Ast::Component | Ast::Store) : Type
      type =
        check node.type

      default =
        check node.default

      result =
        Comparer.compare type, default

      raise PropertyTypeMismatch, {
        "name"     => node.name.value,
        "got"      => default,
        "expected" => type,
        "node"     => node,
      } unless result

      result
    end

    def check(node : Ast::Property) : Type
      check node.type
    end

    def check(nodes : Array(Ast::Property), component : Ast::Component | Ast::Store) : Type
      nodes.each { |node| check node, component }

      NEVER
    end
  end
end
