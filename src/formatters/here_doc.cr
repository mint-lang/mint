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

      "<<#{node.modifier}#{node.token}#{value}#{node.token}"
    end
  end
end
