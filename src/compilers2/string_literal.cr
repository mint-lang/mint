module Mint
  class Compiler2
    def compile(node : Ast::StringLiteral, quote : Bool = false) : Compiled
      value =
        node.value.flat_map do |item|
          case item
          in Ast::Node
            ["${"] + compile(item) + ["}"]
          in String
            [
              item
                .gsub('`', "\\`")
                .gsub("${", "\\${"),
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
