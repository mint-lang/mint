module Mint
  module LS
    class Definition < LSP::RequestMessage
      # Given two Ast::Node::Locations, return a LSP::Range that encompasses both of them
      def selection(location_a : Ast::Node::Location, location_b : Ast::Node::Location) : LSP::Range
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

      # Returns a specific selection for a node. For example, if the node was a component, it would only return the range of the name
      def selection(node : Ast::Node) : LSP::Range
        selection(node.location)
      end

      # Returns the whole selection for a node, including any comments
      def selection_all(node : Ast::Node)
        selection(node)
      end
    end
  end
end
