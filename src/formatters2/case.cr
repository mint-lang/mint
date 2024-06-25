module Mint
  class Formatter2
    def format(node : Ast::Case) : Nodes
      condition =
        format node.condition

      items =
        node.branches + node.comments

      body =
        list items

      await =
        if node.await
          ["await "] of Node
        else
          [] of Node
        end

      ["case "] + await + condition + [" {", Indent.new([:ln] + body), :ln, "}"]
    end
  end
end
