module Mint
  class Formatter
    def format(node : Ast::StringLiteral) : String
      value =
        node.value.gsub('"', "\\\"")

      if value.size > 56 && node.broken
        result = "\"#{value[0, 56]}\" \\\n"
        position = 56
        while value.size > position
          result += "\"#{value[position, 56]}\" \\\n"
          position += 56
        end
        result.rstrip("\\ \n")
      else
        %("#{value}")
      end
    end
  end
end
