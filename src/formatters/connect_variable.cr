module Mint
  class Formatter
    def format(node : Ast::ConnectVariable) : String
      name =
        format node.name

      target =
        node.target.try { |item| format item }

      if target
        "#{name} as #{target}"
      else
        name
      end
    end
  end
end
