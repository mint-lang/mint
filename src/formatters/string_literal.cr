module Mint
  class Formatter
    def format(node : Ast::StringLiteral) : String
      value =
        node.value.gsub('"', "\\\"")

      # Check if we need to break the string or not
      if value.size > 56 && node.broken
        position = 0
        result = ""

        while value.size > position
          result += "\"#{skip { value[position, 56] }}\" \\\n"
          position += 56
        end

        # Remove the last "\\ \n"
        result.rstrip("\\ \n")
      else
        %("#{skip { value }}")
      end
    end
  end
end
