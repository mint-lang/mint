module Mint
  class Compiler
    def compile(node : Ast::Directives::Inline) : Compiled
      inlined =
        Raw.new(node.file_contents.gsub("\\", "\\\\").gsub("`", "\\`"))

      # TODO: Maybe use `js.string`?
      ["`", inlined, "`"] of Item
    end
  end
end
