module Mint
  class Formatter
    def format(node : Ast::HtmlStyle) : String
      name =
        node.name.value

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
