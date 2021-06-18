module Mint
  class Formatter
    def format(node : Ast::Use) : String
      data =
        format node.data, node.condition

      if condition = node.condition
        condition =
          " when {\n#{indent(format(condition))}\n}"
      end

      "use #{node.provider} #{data}#{condition}"
    end
  end
end
