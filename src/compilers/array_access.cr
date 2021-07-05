module Mint
  class Compiler
    def _compile(node : Ast::ArrayAccess) : Codegen::Node
      type =
        cache[node.lhs]

      lhs =
        Codegen.source_mapped(node.lhs, compile node.lhs)

      index =
        case node.index
        in Int64
          node.index.to_s
        in Ast::Node
          node_index = node.index.as(Ast::Node)
          Codegen.source_mapped(node_index, compile node_index)
        end

      if type.name == "Tuple" && node.index.is_a?(Int64)
        Codegen.join [lhs, "[", index, "]"]
      else
        Codegen.join ["_at(", lhs, ", ", index, ")"]
      end
    end
  end
end
