module Mint
    module LS
      class Definition < LSP::RequestMessage
        def selection(node : Ast::Style)
          # Select only the name part of the style
          #     style app {
          #           ^^^
          selection(node.name)
        end
      end
    end
  end
  