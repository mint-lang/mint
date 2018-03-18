class Compiler
  def compile(nodes : Array(Ast::Style), component : Ast::Component) : Nil
    nodes.each do |node|
      compile node, component
    end
  end

  def compile(node : Ast::Style, component : Ast::Component) : Nil
    prefix =
      StringInflection
        .kebab(component.name + "-" + node.name.value)
        .gsub('.', '-')

    compile prefix, prefix, node.definitions

    node.medias.each_with_index do |item, index|
      compile prefix + "-media-#{index}", prefix, item.definitions, item.content
    end

    node.selectors.each do |item|
      item.selectors.each do |selector|
        compile prefix + selector, prefix, item.definitions
      end
    end
  end
end
