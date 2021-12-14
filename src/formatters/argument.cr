module Mint
  class Formatter
    def format(node : Ast::Argument) : String
      name =
        format node.name

      type =
        format node.type

      default =
        format node.default

      head =
        "#{name} : #{type}"

      if default
        "#{head} = #{default}"
      else
        head
      end
    end
  end
end
