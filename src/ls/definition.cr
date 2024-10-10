module Mint
  module LS
    # This is the class that handles the "textDocument/definition" request.
    class Definition < LSP::RequestMessage
      property params : LSP::TextDocumentPositionParams

      def execute(server) : Array(LSP::LocationLink) | Array(LSP::Location) | LSP::Location | Nil
        workspace =
          server.workspace(params.path)

        case type_checker = workspace.result
        in TypeChecker
          stack =
            type_checker.artifacts.ast.nodes_at_cursor(
              column: params.position.character,
              path: params.text_document.path,
              line: params.position.line + 1)

          # stack.each do |item|
          #   print item.class.name.sub("Mint::Ast::", "")
          #   case item
          #   when Ast::Id, Ast::Variable
          #     print "(#{item.value})"
          #   end
          #   puts item.location.start
          # end

          return unless node = stack[0]?

          has_link_support =
            server
              .params
              .try(&.capabilities.text_document)
              .try(&.definition)
              .try(&.link_support) || false

          links =
            Definitions.new(
              type_checker: type_checker,
              params: params,
              stack: stack,
            ).definition(node)

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
        in Error
        end
      end

      def to_lsp_location(location_link : LSP::LocationLink) : LSP::Location
        LSP::Location.new(
          range: location_link.target_selection_range,
          uri: location_link.target_uri,
        )
      end
    end
  end
end
