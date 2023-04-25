module Mint
  module LS
    # This is the class that handles the "textDocument/definition" request.
    class Definition < LSP::RequestMessage
      property params : LSP::TextDocumentPositionParams

      def execute(server) : LSP::LocationLink | LSP::Location?
        uri =
          URI.parse(params.text_document.uri)

        workspace =
          Workspace[uri.path.to_s]

        unless workspace.error
          stack =
            server.nodes_at_cursor(params)

          html_style(server, workspace, stack) ||
            html_attribute(server, workspace, stack) ||
            html_component(server, workspace, stack)
        end
      end

      def with_stack(stack : Array(Ast::Node), &)
        yield StackReader.new(stack)
      end

      def selection(location : Ast::Node::Location) : LSP::Range
        LSP::Range.new(
          start: LSP::Position.new(
            line: location.start[0] - 1,
            character: location.start[1]
          ),
          end: LSP::Position.new(
            line: location.end[0] - 1,
            character: location.end[1]
          )
        )
      end

      # Returns the range for the name part for a node
      def selection(node : Ast::Node) : LSP::Range
        selection(node.location)
      end

      def selection(node : Ast::Component) : LSP::Range
        # Select only the name part of the component
        #   global component MintComponent {
        #                    ^^^^^^^^^^^^^

        start_line, start_column = node.location.start

        node.comment.try do |comment|
          start_line, start_column = comment.location.end
        end

        # TODO: Change parser so component name is a node?
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

      def selection(node : Ast::HtmlAttribute) : LSP::Range
        # Select only the name part of the attribute
        # <Component attribute={value}>
        #            ^^^^^^^^^
        selection(node.name)
      end

      def selection(node : Ast::HtmlComponent) : LSP::Range
        # Select only the name part of the component
        # <Component attribute={value}>
        #  ^^^^^^^^^
        selection(node.component)
      end

      def selection(node : Ast::HtmlStyle) : LSP::Range
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

      def selection(node : Ast::Property) : LSP::Range
        # Select only the name part of the property
        #     property size : String = "small"
        #              ^^^^
        selection(node.name)
      end

      def selection(node : Ast::Style) : LSP::Range
        # Select only the name part of the style
        #     style app {
        #           ^^^
        selection(node.name)
      end

      def find_component(workspace : Workspace, name : String) : Ast::Component?
        # Do not include any core component
        return if Core.ast.components.any?(&.name.== name)

        workspace.ast.components.find(&.name.== name)
      end

      def has_link_support(server : Server)
        server.params.try &.capabilities.try &.text_document.try &.definition.try &.link_support
      end

      # Generates a LSP::LocationLink that links from source to the target node
      def location_link(server : Server, source : Ast::Node, target : Ast::Node) : LSP::LocationLink | LSP::Location
        if has_link_support(server)
          LSP::LocationLink.new(
            origin_selection_range: selection(source),
            target_uri: "file://#{target.location.filename}",
            target_range: selection(target.location),
            target_selection_range: selection(target)
          )
        else
          LSP::Location.new(
            range: selection(target),
            uri: "file://#{target.location.filename}",
          )
        end
      end
    end
  end
end
