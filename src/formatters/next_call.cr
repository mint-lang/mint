module Mint
  class Formatter
    def format(node : Ast::NextCall) : String
      data =
        format node.data

      if data.includes?("\n")
        "next\n#{data.indent}"
      else
        "next #{data}"
      end
    end
  end
end
