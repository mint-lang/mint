module Mint
  class Formatter
    def format(node : Ast::HtmlStyle) : String
      name =
        if node.entity
          "#{node.entity}.#{node.name.value}"
        else
          node.name.value
        end

      arguments =
        unless node.arguments.empty?
          items =
            format node.arguments, ", "

          "(#{items})"
        end

      "::#{name}#{arguments}"
    end
  end
end
