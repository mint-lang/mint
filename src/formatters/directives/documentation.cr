module Mint
  class Formatter
    def format(node : Ast::Directives::Documentation)
      "@documentation(#{format node.entity})"
    end
  end
end
