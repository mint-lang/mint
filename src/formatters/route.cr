module Mint
  class Formatter
    def format(node : Ast::Route) : String
      body =
        list [node.expression] + node.head_comments + node.tail_comments

      args =
        format node.arguments, ", "

      arguments =
        if node.arguments.empty?
          ""
        else
          " (#{args})"
        end

      "#{node.url}#{arguments} {\n#{indent(body)}\n}"
    end
  end
end
