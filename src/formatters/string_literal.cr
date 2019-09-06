module Mint
  class Formatter
    def skip_string(string)
      if string.includes?("\n")
        skip { string }
      else
        string
      end
    end

    def format(node : Ast::StringLiteral) : String
      value =
        node.value.gsub('"', "\\\"")

      # Check if we need to break the string or not
      if value.size > 56 && node.broken
        position = 0
        result = ""

        while value.size > position
          result += "\"#{skip_string(value[position, 56])}\" \\\n"
          position += 56
        end

        # Remove the last "\\ \n"
        result.rstrip("\\ \n")
      else
        %("#{skip_string(value)}")
      end
    end
  end
end
