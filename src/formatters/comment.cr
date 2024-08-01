module Mint
  class Formatter
    def format(node : Ast::Comment) : Nodes
      value =
        node.content.strip

      formatted =
        if node.type.block?
          if value.includes?('\n')
            ["/*", Line.new(1), value, Line.new(1), "*/"] of Node
          else
            ["/* ", value, " */"] of Node
          end
        else
          if value.size > 0 && value[0] != ' '
            ["// #{value}"] of Node
          else
            ["//#{value}"] of Node
          end
        end

      if node.next_comment
        formatted + [Line.new(1)] + format(node.next_comment)
      else
        formatted
      end
    end
  end
end
