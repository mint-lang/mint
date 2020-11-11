module Mint
  class Compiler
    def compile(node : Ast::StringLiteral, qoute : Bool = false) : String
      if checked.includes?(node)
        _compile(node, qoute)
      else
        ""
      end
    end

    def _compile(node : Ast::StringLiteral, qoute : Bool = false) : String
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

      if qoute
        %(`"#{value}"`)
      else
        "`#{value}`"
      end
    end
  end
end
