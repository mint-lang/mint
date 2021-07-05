module Mint
  class Compiler
    def compile(node : Ast::If, block : Proc(Codegen::Node, Codegen::Node)? = nil) : Codegen::Node
      if checked.includes?(node)
        _compile node, block
      else
        ""
      end
    end

    def _compile(node : Ast::If, block : Proc(Codegen::Node, Codegen::Node)? = nil) : Codegen::Node
      condition =
        compile node.condition

      truthy_item, falsy_item =
        node.branches

      truthy =
        case item = truthy_item
        when Array(Ast::CssDefinition)
          _compile item, block: block
        else
          Codegen.source_mapped(item, compile item)
        end

      falsy =
        case item = falsy_item
        when Array(Ast::CssDefinition)
          _compile item, block: block
        when Ast::If
          Codegen.source_mapped(item, compile item, block: block)
        when Ast::Node
          Codegen.source_mapped(item, compile item)
        else
          "null"
        end

      Codegen.source_mapped(node, Codegen.join ["(", condition, " ? ", truthy, " : ", falsy, ")"])
    end
  end
end
