module Mint
  module LS
    # This is the class that handles the "textDocument/definition" request.
    class Definition < LSP::RequestMessage
      property params : LSP::TextDocumentPositionParams

      def execute(server) : Array(LSP::LocationLink) | Array(LSP::Location) | LSP::Location | Nil
        uri =
          URI.parse(params.text_document.uri)

        workspace =
          Workspace[uri.path.to_s]

        unless workspace.error
          stack =
            server.nodes_at_cursor(params)

          return unless node = stack[0]?

          # stack.each do |item|
          #   print item.class.name.sub("Mint::Ast::", "")
          #   case item
          #   when Ast::Id, Ast::Variable
          #     print "(#{item.value})"
          #   end
          #   puts item.location.start
          # end

          has_link_support =
            server
              .params
              .try(&.capabilities.text_document)
              .try(&.definition)
              .try(&.link_support) || false

          links = definition(node, workspace, stack)

          case links
          when Array(LSP::LocationLink)
            # Return a singular `LSP::Location` if possible
            return to_lsp_location(links.first) if !has_link_support && links.size == 1

            return links.map { |link| to_lsp_location(link) } if !has_link_support

            # Prefer nil rather than an empty array
            links unless links.empty?
          when LSP::LocationLink
            return to_lsp_location(links) if !has_link_support

            [links]
          end
        end
      end

      def definition(node : Ast::Node, workspace : Workspace, stack : Array(Ast::Node))
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

      def to_lsp_location(location_link : LSP::LocationLink) : LSP::Location
        LSP::Location.new(
          range: location_link.target_selection_range,
          uri: location_link.target_uri,
        )
      end

      # Returns a `LSP::LocationLink` that links from *source* to the *target* node
      #
      # The *parent* node is used to provide the full range for the *target* node.
      # For example, for a function, *target* would be the function name, and *parent*
      # would be the whole node, including function body and any comments
      def location_link(source : Ast::Node, target : Ast::Node, parent : Ast::Node) : LSP::LocationLink
        LSP::LocationLink.new(
          origin_selection_range: to_lsp_range(source.location),
          target_uri: "file://#{target.location.filename}",
          target_range: to_lsp_range(parent.location),
          target_selection_range: to_lsp_range(target.location)
        )
      end
    end
  end
end
