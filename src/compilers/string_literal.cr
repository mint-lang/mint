module Mint
  class Compiler
    def compile(node : Ast::StringLiteral, quote : Bool = false) : Codegen::Node
      if checked.includes?(node)
        _compile(node, quote)
      else
        ""
      end
    end

    def _compile(node : Ast::StringLiteral, quote : Bool = false) : Codegen::Node
      value =
        Codegen.join(node.value) do |item|
          case item
          when Ast::Node
            Codegen.join ["${", compile(item), "}"]
          when String
            item
              .gsub('`', "\\`")
              .gsub("${", "\\${")
          else
            ""
          end
        end

      if quote
        Codegen.join ["`\"", value, "\"`"]
      else
        Codegen.join ["`", value, "`"]
      end
    end
  end
end
