module Mint
  class Formatter
    def format(node : Ast::Do) : String
      items =
        node.statements + node.comments

      body =
        list items

      catches =
        format node.catches, " "

      finally =
        format node.finally

      ["do {\n#{body.indent}\n}",
       catches,
       finally.to_s,
      ].reject(&.strip.empty?)
        .join(" ")
    end
  end
end
