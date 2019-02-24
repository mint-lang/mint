module Mint
  class Formatter
    def format(node : Ast::Routes) : String
      body =
        list node.routes + node.comments

      "routes {\n#{indent(body)}\n}"
    end
  end
end
