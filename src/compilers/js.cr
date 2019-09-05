module Mint
  class Compiler
    def _compile(node : Ast::Js) : String
      value =
        node.value.map do |item|
          case item
          when Ast::Node
            compile item
          else
            item
          end
        end.join("").strip

      if value.empty?
        ""
      else
        "(#{value})"
      end
    end
  end
end
