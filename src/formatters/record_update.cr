module Mint
  class Formatter
    def format(node : Ast::RecordUpdate) : String
      expression =
        format node.expression

      fields =
        format node.fields

      if node.fields.size >= 2 || fields.any? { |string| replace_skipped(string).includes?('\n') }
        "{ #{expression} |\n#{indent(fields.join(",\n"))}\n}"
      else
        "{ #{expression} | #{fields.join} }"
      end
    end
  end
end
