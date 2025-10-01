module Mint
  class Compiler
    def compile(node : Ast::Directives::Size) : Compiled
      size =
        (sizes[lookups[node][0]] ||= Size.new)

      [Signal.new(size)] of Item
    end
  end
end
