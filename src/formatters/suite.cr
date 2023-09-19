module Mint
  class Formatter
    def format(node : Ast::Suite) : String
      body =
        list(node.constants + node.tests + node.comments + node.functions)

      name =
        format node.name

      "suite #{name} {\n#{indent(body)}\n}"
    end
  end
end
