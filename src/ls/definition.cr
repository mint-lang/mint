module Mint
  module LS
    # This is the class that handles the "textDocument/definition" request.
    class Definition < LSP::RequestMessage
      property params : LSP::TextDocumentPositionParams

      def execute(server) : Array(LSP::LocationLink | LSP::Location) | LSP::LocationLink | LSP::Location | Nil
        uri =
          URI.parse(params.text_document.uri)

        workspace =
          Workspace[uri.path.to_s]

        unless workspace.error
          stack =
            server.nodes_at_cursor(params)

          if node = stack[0]?
            definition(node, server, workspace, stack)
          end
        end
      end

      def definition(node : Ast::Node, server : Server, workspace : Workspace, stack : Array(Ast::Node))
        nil
      end

      def cursor_intersects?(node : Ast::Node, position : LSP::Position) : Bool
        node.location.contains?(position.line + 1, position.character)
      end

      def cursor_intersects?(node : Ast::Node, params : LSP::TextDocumentPositionParams) : Bool
        cursor_intersects?(node, params.position)
      end

      def cursor_intersects?(node : Ast::Node) : Bool
        cursor_intersects?(node, params)
      end

      def find_component(workspace : Workspace, name : String) : Ast::Component?
        # Do not include any core component
        return if Core.ast.components.any?(&.name.value.== name)

        workspace.ast.components.find(&.name.value.== name)
      end

      def has_link_support?(server : Server)
        !!(server.params.try &.capabilities.try &.text_document.try &.definition.try &.link_support)
      end

      def to_lsp_range(location : Ast::Node::Location) : LSP::Range
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

      # Returns a `LSP::LocationLink` that links from *source* to the *target* node
      # if the language server client has link support, otherwise it returns `LSP::Location`.
      #
      # When returning a `LSP::LocationLink`, *parent* is used to provide the full range
      # for the *target* node. For example, for a function, *target* would be the function name,
      # and *parent* would be the whole node, including function body and any comments
      def location_link(server : Server, source : Ast::Node, target : Ast::Node, parent : Ast::Node) : LSP::LocationLink | LSP::Location
        if has_link_support?(server)
          LSP::LocationLink.new(
            origin_selection_range: to_lsp_range(source.location),
            target_uri: "file://#{target.location.filename}",
            target_range: to_lsp_range(parent.location),
            target_selection_range: to_lsp_range(target.location)
          )
        else
          LSP::Location.new(
            range: to_lsp_range(target.location),
            uri: "file://#{target.location.filename}",
          )
        end
      end
    end
  end
end
