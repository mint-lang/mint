module Mint
  module LS
    class Definitions
      def initialize(
        *,
        @params : LSP::TextDocumentPositionParams,
        @type_checker : TypeChecker,
        @stack : Array(Ast::Node)
      )
      end

      def definition(node : Ast::Node)
        nil
      end

      def cursor_intersects?(node : Ast::Node, position : LSP::Position) : Bool
        node.contains?(position.line + 1, position.character)
      end

      def cursor_intersects?(node : Ast::Node, params : LSP::TextDocumentPositionParams) : Bool
        cursor_intersects?(node, params.position)
      end

      def cursor_intersects?(node : Ast::Node) : Bool
        cursor_intersects?(node, @params)
      end

      def find_component(name : String) : Ast::Component?
        # Do not include any core component
        return if Core.ast.components.any?(&.name.value.== name)

        @type_checker.ast.components.find(&.name.value.== name)
      end

      def to_lsp_range(node : Ast::Node) : LSP::Range
        LSP::Range.new(
          start: LSP::Position.new(
            character: node.from.column,
            line: node.from.line - 1
          ),
          end: LSP::Position.new(
            character: node.to.column,
            line: node.to.line - 1
          )
        )
      end

      # Returns a `LSP::LocationLink` that links from *source* to the *target* node
      #
      # The *parent* node is used to provide the full range for the *target* node.
      # For example, for a function, *target* would be the function name, and *parent*
      # would be the whole node, including function body and any comments
      def location_link(source : Ast::Node, target : Ast::Node, parent : Ast::Node) : LSP::LocationLink
        LSP::LocationLink.new(
          origin_selection_range: to_lsp_range(source),
          target_selection_range: to_lsp_range(target),
          target_uri: "file://#{target.file.path}",
          target_range: to_lsp_range(parent),
        )
      end
    end
  end
end
