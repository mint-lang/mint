module Mint
  class Compiler
    def _compile(node : Ast::Get) : String
      body =
        compile node.body

      wheres =
        compile node.where.try(&.statements) || [] of Ast::WhereStatement

      wheres_separator =
        wheres.any? ? "\n\n" : ""

      name =
        node.name.value

      body =
        [wheres.join("\n\n"),
         wheres_separator,
         "return #{body}",
        ].join("")
          .indent

      "get #{name}() {\n#{body}\n}"
    end
  end
end
