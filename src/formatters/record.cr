module Mint
  class Formatter
    def format(node : Ast::Record, multiline = false) : String
      case node
      when Ast::EnumRecord
        body =
          format node.fields

        if node.new_line?
          body.join(",\n")
        else
          body.join(", ")
        end
      when Ast::Record
        body =
          format node.fields

        if node.fields.size >= 2 || multiline || body.any? do |string|
             replace_skipped(string).includes?('\n')
           end
          "{\n#{indent(body.join(",\n"))}\n}"
        else
          "{ #{body.join(", ")} }"
        end
      else
        ""
      end
    end
  end
end
