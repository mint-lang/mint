module Mint
  class Compiler2
    def compile(node : Ast::Js) : Compiled
      compile node do
        case item = node.value.first?
        when String
          node.value[0] = item.lstrip
        end

        case item = node.value.last?
        when String
          node.value[node.value.size - 1] = item.rstrip
        end

        value =
          node.value.flat_map do |entity|
            case entity
            in Ast::Node
              compile entity
            in String
              entity.gsub("\\`", '`')
            end
          end

        if value.empty?
          ["undefined"] of Item
        else
          ["("] + value + [")"]
        end
      end
    end
  end
end
