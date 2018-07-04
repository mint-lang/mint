module Mint
  class Formatter
    def format(node : Ast::Routes) : String
      body =
        list node.routes + node.comments

      "routes {\n#{body.indent}\n}"
    end
  end
end
