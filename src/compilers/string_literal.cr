module Mint
  class Compiler
    def compile(node : Ast::StringLiteral, quote : Bool = false) : Compiled
      compile node do
        value =
          node.value.flat_map do |item|
            case item
            in Ast::Node
              ["${"] + compile(item) + ["}"]
            in String
              [
                item
                  .gsub('`', "\\`")
                  .gsub("${", "\\${")
                  .gsub("\\\"", "\"")
                  .gsub("\\\#{", "\#{"),
              ]
            end
          end

        if quote
          [%(`")] + value + [%("`)]
        else
          ["`"] + value + ["`"]
        end
      end
    end
  end
end
