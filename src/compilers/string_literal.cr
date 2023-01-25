module Mint
  class Compiler
    def compile(node : Ast::StringLiteral, quote : Bool = false) : String
      node.in?(checked) ? _compile(node, quote) : ""
    end

    def _compile(node : Ast::StringLiteral, quote : Bool = false) : String
      value =
        node
          .value
          .join do |item|
            case item
            when Ast::Node
              "${#{compile(item)}}"
            when String
              item
                .gsub('`', "\\`")
                .gsub("${", "\\${")
            else
              ""
            end
          end

      if quote
        %(`"#{value}"`)
      else
        "`#{value}`"
      end
    end
  end
end
