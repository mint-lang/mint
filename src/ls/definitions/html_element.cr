module Mint
  module LS
    class Definitions
      def definition(node : Ast::HtmlElement)
        node.styles.each do |style|
          next unless cursor_intersects?(style)

          return definition(style)
        end
      end
    end
  end
end
