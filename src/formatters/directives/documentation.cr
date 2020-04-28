module Mint
  class Formatter
    def format(node : Ast::Directives::Documentation)
      "@documentation(#{node.entity})"
    end
  end
end
