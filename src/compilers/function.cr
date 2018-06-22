module Mint
  class Compiler
    def compile(node : Ast::Function, contents = "") : String
      expression =
        compile node.body

      wheres =
        compile node.wheres

      arguments =
        compile node.arguments, ", "

      wheres_separator =
        wheres.any? ? "\n\n" : ""

      contents_separator =
        contents.empty? ? "" : "\n\n"

      body =
        [wheres.join("\n\n"),
         wheres_separator,
         contents,
         contents_separator,
         "return #{expression}",
        ].join("")
          .indent

      "#{node.name.value}(#{arguments}) {\n#{body}\n}"
    end
  end
end
