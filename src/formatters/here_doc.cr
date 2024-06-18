module Mint
  class Formatter
    def format(node : Ast::HereDocument) : String
      value =
        node.value.reduce("") do |memo, item|
          case item
          when Ast::Node
            memo + format(item)
          when String
            memo + skip_string(item)
          else
            memo
          end
        end

      flags =
        if node.highlight
          "(highlight)"
        end

      "<<#{node.modifier}#{node.token}#{flags}#{value}#{node.token}"
    end
  end
end
