module Mint
  class TypeChecker
    type_error PropertyTypeMismatch

    def check(node : Ast::Property, component : Ast::Component | Ast::Store) : Type
      type =
        resolve node.type

      default =
        resolve node.default

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
      resolve node.type
    end

    def check(nodes : Array(Ast::Property), component : Ast::Component | Ast::Store) : Type
      nodes.each { |node| resolve node, component }

      NEVER
    end
  end
end
