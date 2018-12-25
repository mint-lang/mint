module Mint
  class Formatter
    def format(node : Ast::ConnectVariable) : String
      variable =
        format node.variable

      name =
        node.name.try { |item| format item }

      if name
        "#{variable} as #{name}"
      else
        variable
      end
    end
  end
end
