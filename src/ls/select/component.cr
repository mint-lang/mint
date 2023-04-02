module Mint
  module LS
    class Definition < LSP::RequestMessage
      def selection(node : Ast::Component)
        # Select only the name part of the component
        #   global component MintComponent {
        #                    ^^^^^^^^^^^^^

        start_line, start_column = node.location.start

        # TODO: Change compiler so component name is a node?
        offset = if node.global?
                   "global component ".size
                 else
                   "component ".size
                 end

        location = Ast::Node::Location.new(
          filename: node.location.filename,
          start: {start_line, start_column + offset},
          end: {start_line, start_column + offset + node.name.size}
        )

        selection(location)
      end
    end
  end
end
