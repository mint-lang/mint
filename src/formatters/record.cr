module Mint
  class Formatter
    def format(node : Ast::Record, multiline = false) : String
      body =
        format node.fields

      if node.fields.size >= 2 || body.any?(&.includes?("\n")) || multiline
        "{\n#{indent(body.join(",\n"))}\n}"
      else
        "{ #{body.join(", ")} }"
      end
    end
  end
end
