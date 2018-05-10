module Mint
  class Formatter
    def format(node : Ast::Connect) : String
      store =
        node.store

      keys =
        if node.keys.size > 6
          format node.keys, ",\n"
        else
          format node.keys, ", "
        end

      if node.keys.size > 6
        "connect #{store} exposing {\n#{keys.indent}\n}"
      else
        "connect #{store} exposing { #{keys} }"
      end
    end
  end
end
