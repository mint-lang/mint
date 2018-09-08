module Mint
  class TypeChecker
    type_error HtmlComponentNotFoundComponent

    def check(node : Ast::HtmlComponent) : Checkable
      component =
        ast.components.find(&.name.==(node.component))

      raise HtmlComponentNotFoundComponent, {
        "name" => node.component,
        "node" => node,
      } unless component

      resolve component

      node.attributes.each { |attribute| resolve attribute, component }

      check_html node.children

      HTML
    end
  end
end
