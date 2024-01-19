module Mint
  class Compiler2
    def compile(node : Ast::Directives::Inline) : Compiled
      ["`", Raw.new(node.file_contents), "`"] of Item
    end
  end
end
