module Mint
  class TypeChecker
    type_error PropertyTypeMismatch

    def check(node : Ast::Property, component : Ast::Component | Ast::Store) : Checkable
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

    def check(node : Ast::Property) : Checkable
      resolve node.type
    end

    def check(nodes : Array(Ast::Property), component : Ast::Component | Ast::Store) : Checkable
      nodes.each { |node| resolve node, component }

      NEVER
    end
  end
end
