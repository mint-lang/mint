module Mint
  class Formatter
    def format(node : Ast::Style) : String
      name =
        format node.name

      body =
        list node.body

      arguments =
        unless node.arguments.empty?
          value =
            format node.arguments

          if value
               .map { |string| replace_skipped(string) }
               .map(&.size).sum > 50
            "(\n#{indent(value.join(",\n"))}\n) "
          else
            "(#{value.join(", ")}) "
          end
        end

      "style #{name} #{arguments}{\n#{indent(body)}\n}"
    end
  end
end
