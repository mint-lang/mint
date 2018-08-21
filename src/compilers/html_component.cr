module Mint
  class Compiler
    def _compile(node : Ast::HtmlComponent) : String
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
        ["$#{underscorize(node.component)}",
         "{ #{attributes} }",
         children]
          .reject(&.empty?)
          .join(", ")

      "_createElement(#{contents})"
    end
  end
end
