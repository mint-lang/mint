module Mint
  class Formatter
    def format(node : Ast::EnumId)
      "#{node.name}::#{node.option}"
    end
  end
end
