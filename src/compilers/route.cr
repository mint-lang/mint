class Compiler
  def compile(node : Ast::Route) : String
    expression =
      compile node.expression

    arguments =
      compile node.arguments, ", "

    mapping =
      node
        .arguments
        .map { |argument| "'#{argument.name.value}'" }
        .join(", ")

    "{
       handler: ((#{arguments}) => { #{expression} }),
       mapping: [#{mapping}],
       path: `#{node.url}`
     }"
  end
end
