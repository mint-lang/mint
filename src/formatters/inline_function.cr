module Mint
  class Formatter
    def format(node : Ast::InlineFunction) : String
      body =
        format node.body, true

      value =
        format node.arguments

      arguments =
        if value.sum { |string| replace_skipped(string).size } > 50
          "\n#{indent(value.join(",\n"))}\n"
        else
          value.join(", ")
        end

      type =
        node.type.try do |item|
          " : #{format(item)}"
        end

      "(#{arguments})#{type} #{body}"
    end
  end
end
