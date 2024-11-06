module Mint
  class Formatter
    def format(node : Ast::Comment) : Nodes
      formatted =
        if node.type.block?
          value =
            node.content.strip

          if value.includes?('\n')
            ["/*", Line.new(1), value, Line.new(1), "*/"] of Node
          else
            ["/* ", value, " */"] of Node
          end
        else
          value =
            node.content.rstrip

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
