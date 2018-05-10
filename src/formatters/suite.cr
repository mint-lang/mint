module Mint
  class Formatter
    def format(node : Ast::Suite) : String
      body =
        format node.tests, "\n\n"

      name =
        format node.name

      "suite #{name} {\n#{body.indent}\n}"
    end
  end
end
