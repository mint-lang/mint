module Mint
  class Formatter
    def format(node : Ast::Case) : String
      condition =
        format node.condition

      items =
        node.branches + node.comments

      body =
        list items

      await =
        "await " if node.await

      "case #{await}#{condition} {\n#{indent(body)}\n}"
    end
  end
end
