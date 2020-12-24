module Mint
  class Compiler
    def _compile(node : Ast::HtmlFragment) : Codegen::Node
      attributes =
        if key = node.key
          js.object({"key" => compile key.value})
        else
          "{}"
        end

      if node.children.empty? && !node.key
        "null"
      else
        items =
          compile node.children

        Codegen.join ["_h(React.Fragment, ", attributes, ", ", js.array(items), ")"]
      end
    end
  end
end
