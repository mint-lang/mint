module Mint
  class Formatter
    def format(node : Ast::HtmlStyle) : String
      name =
        node.name.value

      arguments =
        if node.arguments.any?
          items =
            format node.arguments, ", "

          "(#{items})"
        else
          ""
        end

      "::#{name}#{arguments}"
    end
  end
end
