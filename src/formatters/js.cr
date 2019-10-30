module Mint
  class Formatter
    def format(node : Ast::Js) : String
      body =
        node.value.map do |item|
          format(item)
        end.join("")

      result =
        "`#{body}`"

      if result.includes?("\n")
        skip { result }
      else
        result
      end
    end
  end
end
