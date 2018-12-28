module Mint
  class Compiler
    def _compile(node : Ast::HtmlComponent) : String
      name =
        js.class_of(lookups[node])

      children =
        if node.children.empty?
          ""
        else
          items =
            compile node.children, ", "

          "_array(#{items})"
        end

      attributes =
        node
          .attributes
          .map { |item| compile(item, false).as(String) }
          .join(", ")

      contents =
        ["$#{name}",
         "{ #{attributes} }",
         children]
          .reject(&.empty?)
          .join(", ")

      "_createElement(#{contents})"
    end
  end
end
