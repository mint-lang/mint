module Mint
  class Compiler
    def _compile(node : Ast::Js) : Codegen::Node
      value =
        Codegen.strip(Codegen.join(node.value) do |item|
          case item
          when Ast::Node
            compile item
          else
            item
          end
        end)

      if Codegen.empty? value
        ""
      else
        Codegen.join ["(", Codegen.source_mapped(node, value), ")"]
      end
    end
  end
end
