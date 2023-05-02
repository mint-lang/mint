module Mint
  class Compiler
    def compile(nodes : Array(Ast::Style), component : Ast::Component) : Nil
      nodes.each do |node|
        compile node, component
      end
    end

    def compile(node : Ast::Style, component : Ast::Component) : Nil
      node.in?(checked) ? _compile(node, component) : ""
    end

    def _compile(node : Ast::Style, component : Ast::Component) : Nil
      style_builder.process(node, component.name.value.gsub('.', '·'))
    end
  end
end
