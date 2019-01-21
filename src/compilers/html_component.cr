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

      node.ref.try do |ref|
        attributes << "ref: (instance) => { this._#{ref.value} = instance }"
      end

      contents =
        ["$#{underscorize(node.component)}",
         "{ #{attributes.join(", ")} }",
         children]
          .reject(&.empty?)
          .join(", ")

      "_createElement(#{contents})"
    end
  end
end
