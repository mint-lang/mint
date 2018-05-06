module Mint
  class TypeChecker
    type_error HtmlComponentNotFoundComponent

    def check(node : Ast::HtmlComponent) : Type
      component =
        ast.components.find(&.name.==(node.component))

      raise HtmlComponentNotFoundComponent, {
        "name" => node.component,
        "node" => node,
      } unless component

      node.attributes.each { |attribute| check attribute, component }

      check_html node.children

      HTML
    end
  end
end
