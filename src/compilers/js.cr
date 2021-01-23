module Mint
  class Compiler
    def _compile(node : Ast::Js) : String
      value =
        node.value.join do |item|
          case item
          when Ast::Node
            compile item
          else
            item
          end
        end.strip

      if value.empty?
        ""
      else
        "(#{value})"
      end
    end
  end
end
