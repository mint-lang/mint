module Mint
  class Formatter
    def format(node : Ast::Env)
      "@#{node.name}"
    end
  end
end
