module Mint
  class Formatter
    def format(node : Ast::Do) : String
      statements =
        list node.statements

      catches =
        format node.catches, " "

      finally =
        format node.finally

      ["do {\n#{statements.indent}\n}",
       catches,
       finally.to_s,
      ].reject(&.strip.empty?)
        .join(" ")
    end
  end
end
