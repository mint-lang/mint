module Mint
  class Compiler
    def _compile(node : Ast::Property) : String
      "{original: '#{node.name.value}', name: '#{js.variable_of(node)}'}"
    end
  end
end
