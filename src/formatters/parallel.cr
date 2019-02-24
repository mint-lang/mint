module Mint
  class Formatter
    def format(node : Ast::Parallel) : String
      items =
        node.statements + node.comments

      body =
        list items

      catches =
        format node.catches

      then_branch =
        format node.then_branch

      finally =
        format node.finally

      node.catch_all.try do |catch|
        catches.push format(catch)
      end

      ["parallel {\n#{indent(body)}\n}",
       then_branch.to_s,
       catches.join(" "),
       finally.to_s,
      ].reject(&.strip.empty?)
        .join(" ")
    end
  end
end
