module Mint
  class Formatter
    def format(node : Ast::Case) : String
      condition =
        format node.condition

      items =
        node.branches + node.comments

      body =
        list items

      "case (#{condition}) {\n#{body.indent}\n}"
    end
  end
end
