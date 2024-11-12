module Mint
  module LS
    class FoldingRange < LSP::RequestMessage
      property params : LSP::FoldingRangeParams

      def range(node : Ast::Component) : Array(LSP::FoldingRange)
        range(node, node.comment)
      end

      def range(node : Ast::Module) : Array(LSP::FoldingRange)
        range(node, node.comment)
      end

      def range(node : Ast::Function) : Array(LSP::FoldingRange)
        range(node, node.comment)
      end

      def range(node : Ast::Node, comment : Ast::Comment?) : Array(LSP::FoldingRange)
        if comment
          range(comment.from.line, comment.to.line) +
            range(comment.to.line, node.to.line)
        else
          range(node.from.line, node.to.line)
        end
      end

      def range(node : Ast::Node?) : Array(LSP::FoldingRange)
        [] of LSP::FoldingRange
      end

      def range(start_line, end_line) : Array(LSP::FoldingRange)
        [
          LSP::FoldingRange.new(
            start_line: start_line - 1,
            end_line: end_line - 1),
        ]
      end

      def execute(server)
        workspace =
          server.workspace(params.text_document.path)

        case type_checker = workspace.result
        in TypeChecker
          type_checker.artifacts.ast
            .nodes_at_path(params.text_document.path)
            .reject { |node| node.from.line == node.to.line }
            .flat_map { |node| range(node) }
        in Error
        end
      end
    end
  end
end
