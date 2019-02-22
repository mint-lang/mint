module Mint
  class Formatter
    def format(node : Ast::Suite) : String
      body =
        list node.tests + node.comments

      name =
        format node.name

      "suite #{name} {\n#{indent(body)}\n}"
    end
  end
end
