module Mint
  class Compiler
    def compile(nodes : Array(Ast::Style), component : Ast::Component | Ast::Styles) : Nil
      nodes.each do |node|
        compile node, component
      end
    end

    def compile(node : Ast::Style, component : Ast::Component | Ast::Styles) : Nil
      if checked.includes?(node)
        _compile node, component
      else
        ""
      end
    end

    def _compile(node : Ast::Style, component : Ast::Component | Ast::Styles) : Nil
      style_builder.process(node, component.name.gsub('.', '·'))
      ""
    end
  end
end
