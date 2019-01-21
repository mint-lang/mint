module Mint
  class Compiler
    def _compile(node : Ast::Route) : String
      expression =
        compile node.expression

      arguments =
        compile node.arguments, ", "

      mapping =
        node
          .arguments
          .map { |argument| "'#{argument.name.value}'" }
          .join(", ")

      <<-RESULT
      {
        handler: ((#{arguments}) => {
          #{expression}
        }),
        mapping: [#{mapping}],
        path: `#{node.url}`
      }
      RESULT
    end
  end
end
