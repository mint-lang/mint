module Mint
  module LS
    class Definition < LSP::RequestMessage
      def selection(node : Ast::HtmlStyle)
        # Select only the name part of the component
        #   <div::style>
        #         ^^^^^

        start_line, start_column = node.location.start

        # Skip the first two characters "::"
        location = Ast::Node::Location.new(
          filename: node.location.filename,
          start: {start_line, start_column + 2},
          end: node.location.end
        )

        selection(location)
      end
    end
  end
end
