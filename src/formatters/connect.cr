module Mint
  class Formatter
    def format(node : Ast::Connect) : String
      store =
        node.store

      separated =
        Ast.new_line?(node.keys.first, node.keys.last)

      should_break =
        node.keys.size > 6 || separated

      keys =
        if should_break
          format node.keys, ",\n"
        else
          format node.keys, ", "
        end

      if should_break
        "connect #{store} exposing {\n#{indent(keys)}\n}"
      else
        "connect #{store} exposing { #{keys} }"
      end
    end
  end
end
