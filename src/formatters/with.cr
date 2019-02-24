module Mint
  class Formatter
    def format(node : Ast::With) : String
      body =
        list [node.body] + node.head_comments + node.tail_comments

      "with #{node.name} {\n#{indent(body)}\n}"
    end
  end
end
