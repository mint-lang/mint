module Mint
  class Formatter
    def format(node : Ast::Route) : String
      body =
        format node.expression

      args =
        format node.arguments, ", "

      arguments =
        if node.arguments.empty?
          ""
        else
          " (#{args})"
        end

      "#{node.url}#{arguments} #{body}"
    end
  end
end
