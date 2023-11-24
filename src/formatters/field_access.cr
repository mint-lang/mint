module Mint
  class Formatter
    def format(node : Ast::FieldAccess) : String
      ".#{node.name.value}(#{format(node.type)})"
    end
  end
end
