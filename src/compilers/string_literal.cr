module Mint
  class Compiler
    def compile(node : Ast::StringLiteral, quote : Bool = false) : String
      if checked.includes?(node)
        _compile(node, quote)
      else
        ""
      end
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
