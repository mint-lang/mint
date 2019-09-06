module Mint
  class Formatter
    def format(node : Ast::NextCall) : String
      data =
        format node.data

      if replace_skipped(data).includes?("\n")
        "next\n#{indent(data)}"
      else
        "next #{data}"
      end
    end
  end
end
