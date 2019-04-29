module Mint
  class Formatter
    def format(node : Ast::MemberAccess) : String
      ".#{node.name.value}"
    end
  end
end
