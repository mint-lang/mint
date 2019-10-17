module Mint
  class Compiler
    def compile(nodes : Array(Ast::Style), component : Ast::Component) : Nil
      nodes.each do |node|
        compile node, component
      end
    end

    def compile(node : Ast::Style, component : Ast::Component) : Nil
      if checked.includes?(node)
        _compile node, component
      else
        ""
      end
    end

    def _compile(node : Ast::Style, component : Ast::Component) : Nil
      style_builder.process node
    end
  end
end
