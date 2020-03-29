module Mint
  class Formatter
    def format(node : Ast::Sequence) : String
      items =
        node.statements + node.comments

      body =
        list items

      catches =
        format node.catches

      finally =
        format node.finally

      node.catch_all.try do |catch|
        catches.push format(catch)
      end

      ["sequence {\n#{indent(body)}\n}",
       catches.join(' '),
       finally.to_s,
      ].reject(&.strip.empty?)
        .join(' ')
    end
  end
end
