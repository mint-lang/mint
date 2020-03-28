module Mint
  class Compiler
    def _compile(node : Ast::StringLiteral) : String
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

      "`#{value}`"
    end
  end
end
