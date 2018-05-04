module Mint
  class Formatter
    def format(node : Ast::Module) : String
      body =
        format node.functions, "\n\n"

      "module #{node.name} {\n#{body.indent}\n}"
    end
  end
end
