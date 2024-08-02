module Mint
  class Compiler
    def compile(node : Ast::Directives::Inline) : Compiled
      ["`", Raw.new(node.file_contents.gsub("\\", "\\\\").gsub("`", "\\`")), "`"] of Item
    end
  end
end
