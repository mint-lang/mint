module Mint
  module LS
    class FoldingRange < LSP::RequestMessage
      property params : LSP::FoldingRangeParams
      getter ranges = [] of LSP::FoldingRange

      def range(node : Ast::Component)
        range(node.comment)
        range(node, node.comment)
      end

      def range(node : Ast::Module)
        range(node.comment)
        range(node, node.comment)
      end

      def range(node : Ast::Function)
        range(node.comment)
        range(node, node.comment)
      end

      def range(node : Ast::Node, comment : Ast::Comment?)
        if comment
          range(comment.location.end[0], node.location.end[0])
        else
          range(node.location)
        end
      end

      def range(node : Ast::Node?)
        nil
      end

      def range(location : Ast::Node::Location)
        range(location.start[0], location.end[0])
      end

      def range(start_line, end_line)
        ranges << LSP::FoldingRange.new(
          start_line: start_line - 1,
          end_line: end_line - 1)
      end

      def execute(server)
        unless workspace.error
          server
            .nodes_at_path(params.text_document.path)
            .select { |node| node.location.start[0] != node.location.end[0] }
            .compact_map { |node| range(node) }
        end

        ranges
      end

      private def workspace
        Workspace[params.text_document.path]
      end
    end
  end
end
