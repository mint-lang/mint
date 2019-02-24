module Mint
  class Formatter
    def format(node : Ast::Try) : String
      statements =
        list node.statements + node.comments

      catches =
        format node.catches

      node.catch_all.try do |catch|
        catches.push format(catch)
      end

      "try {\n#{indent(statements)}\n} #{catches.join(" ")}".strip
    end
  end
end
