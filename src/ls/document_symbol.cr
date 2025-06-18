module Mint
  module LS
    class DocumentSymbol < LSP::RequestMessage
      property params : LSP::DocumentSymbolParams

      def symbol(node : Ast::Node) : LSP::SymbolInformation?
        case node
        when Ast::Component, Ast::Module, Ast::Provider, Ast::Store
          LSP::SymbolInformation.new(
            location: location_from_node(node),
            name: node.name.value,
            kind: :module)
        when Ast::Property
          case parent = node.parent
          when Ast::Component
            LSP::SymbolInformation.new(
              name: "#{parent.name.value}.#{node.name.value}",
              location: location_from_node(node),
              kind: :property)
          end
        when Ast::Style
          case parent = node.parent
          when Ast::Component
            LSP::SymbolInformation.new(
              name: "#{parent.name.value}.#{node.name.value}",
              location: location_from_node(node),
              kind: :object)
          end
        when Ast::Get, Ast::State
          case parent = node.parent
          when Ast::Component, Ast::Store, Ast::Provider
            kind =
              case node
              when Ast::Get
                LSP::SymbolKind::Variable
              else
                LSP::SymbolKind::Field
              end

            LSP::SymbolInformation.new(
              name: "#{parent.name.value}.#{node.name.value}",
              location: location_from_node(node),
              kind: kind)
          end
        when Ast::Function, Ast::Constant
          case parent = node.parent
          when Ast::Component, Ast::Store, Ast::Module, Ast::Provider
            kind =
              case node
              when Ast::Constant
                LSP::SymbolKind::Constant
              else
                LSP::SymbolKind::Function
              end

            LSP::SymbolInformation.new(
              name: "#{parent.name.value}.#{node.name.value}",
              location: location_from_node(node),
              kind: kind)
          end
        end
      end

      def location_from_node(node : Ast::Node)
        LSP::Location.new(
          uri: "file://#{node.file.path}",
          range: LSP::Range.new(
            start: LSP::Position.new(node.from.line - 1, node.from.column),
            end: LSP::Position.new(node.to.line - 1, node.to.column)))
      end

      def execute(server)
        path =
          params.text_document.path

        case ast = server.workspace(path).ast(path)
        when Ast
          ast.nodes.compact_map { |node| symbol(node) }
        end
      end
    end
  end
end
