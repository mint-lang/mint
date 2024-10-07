module Mint
  module LS
    # This is the class that handles the "textDocument/hover" request.
    class Hover < LSP::RequestMessage
      property params : LSP::TextDocumentPositionParams

      # Fallback handler for nil, obviously it should not happen.
      def hover(
        node : Nil,
        workspace : FileWorkspace,
        type_checker : TypeChecker
      ) : Array(String)
        ["This should not happen! Please create an issue about this!"]
      end

      # Fallback handler for nodes that does not have a handler yet.
      def hover(
        node : Ast::Node,
        workspace : FileWorkspace,
        type_checker : TypeChecker
      ) : Array(String)
        type =
          type_of(node, type_checker)

        [
          "Type information for: #{node.class}\n",
          type,
        ].compact
      end

      # Returns the type information of a node from the workspace
      def type_of(node : Ast::Node, type_checker : TypeChecker)
        type_checker
          .cache[node]?
          .try(&.to_pretty)
          .try { |value| "```\n#{value}\n```" }
      end

      def execute(server)
        # Get the URI of the text document
        uri =
          URI.parse(params.text_document.uri)

        # Get the workspace associated with the text document
        # this could take a while because the workspace parses
        # and type checks all of its source files.
        workspace =
          server.ws(uri.path.to_s)

        contents =
          case type_checker = workspace.result
          in Error
            # If the workspace has an error we cannot really
            # provide and hover information, so we just provide
            # the error instead.
            [
              "Cannot provide hover data because of an error:\n",
              "```\n#{type_checker.to_terminal}\n```",
            ]
          in TypeChecker
            nodes =
              type_checker
                .artifacts
                .ast
                .nodes_at_cursor(
                  column: params.position.character,
                  path: params.text_document.path,
                  line: params.position.line + 1)

            # nodes.each do |item|
            #   print item.class.name.sub("Mint::Ast::", "")
            #   case item
            #   when Ast::Id, Ast::Variable
            #     print "(#{item.value})"
            #   end
            #   puts item.location.start
            # end

            parent = nodes[1]?
            node = nodes[0]?

            case node
            when Ast::Variable, Ast::Id
              # If the first node under the cursor is a `Ast::Variable`
              # or `Ast::Id`, then get the associated node information
              # and hover that otherwise get the hover information of
              # the parent.
              lookup =
                type_checker.variables[node]?

              if lookup
                case item = lookup[0]
                when Tuple(Ast::Node, Int32)
                  hover(item[0], workspace, type_checker)
                when Ast::Node
                  hover(item, workspace, type_checker)
                else
                  [item.to_s]
                end
              else
                hover(parent, workspace, type_checker)
              end
            else
              hover(node, workspace, type_checker)
            end
          end

        # Send the response.
        {contents: contents.compact}
      end
    end
  end
end
