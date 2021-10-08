module Mint
  class Formatter
    def format(node : Ast::Block, inline = false) : String
      body =
        list node.statements

      if !inline || replace_skipped(body).includes?('\n') || node.new_line?
        "{\n#{indent(body)}\n}"
      else
        "{ #{body} }"
      end
    end
  end
end
