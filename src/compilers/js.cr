module Mint
  class Compiler
    def _compile(node : Ast::Js) : String
      node.value.map do |item|
        case item
        when Ast::Node
          compile item
        else
          item
        end
      end.join("").strip
    end
  end
end
