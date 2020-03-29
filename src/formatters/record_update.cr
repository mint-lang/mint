module Mint
  class Formatter
    def format(node : Ast::RecordUpdate) : String
      variable =
        format node.variable

      fields =
        format node.fields

      if node.fields.size >= 2 || fields.any? { |string| replace_skipped(string).includes?('\n') }
        "{ #{variable} |\n#{indent(fields.join(",\n"))}\n}"
      else
        "{ #{variable} | #{fields.join("")} }"
      end
    end
  end
end
