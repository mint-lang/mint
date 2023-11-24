module Mint
  class Formatter
    def format(node : Ast::Map) : String
      body =
        format node.fields

      types =
        node.types.try do |items|
          " of #{format(items[0])} => #{format(items[1])}"
        end

      formatted =
        if node.fields.size >= 2 || body.any? do |string|
             replace_skipped(string).includes?('\n')
           end
          "{\n#{indent(body.join(",\n"))}\n}"
        else
          body =
            body.join(", ").presence.try { |v| " #{v} " } || " "

          "{#{body}}"
        end

      "#{formatted}#{types}"
    end
  end
end
