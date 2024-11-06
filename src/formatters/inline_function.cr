module Mint
  class Formatter
    def format(node : Ast::InlineFunction) : Nodes
      body =
        format node.body, BlockFormat::Inline

      arguments =
        format_arguments node.arguments

      type =
        format(node.type) do |item|
          [" : "] + format(item)
        end

      arguments + type + [" "] + body
    end
  end
end
