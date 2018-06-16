module Mint
  class Formatter
    def format(node : Ast::Alias) : String
      types =
        format node.types, " | "

      "alias #{node.name} = #{types}"
    end
  end
end
