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
      prefix =
        StringInflection
          .kebab(component.name + "_" + node.name.value)
          .gsub('.', '_')

      compile prefix, prefix, node.definitions

      node.medias.each_with_index do |item, index|
        compile prefix + "_media_#{index}", prefix, item.definitions, item.content
      end

      node.selectors.each do |item|
        item.selectors.each do |selector|
          compile prefix + selector, prefix, item.definitions
        end
      end
    end
  end
end
