module Mint
  module LS
    # This is the class that handles the "textDocument/hover" request.
    class Hover < LSP::RequestMessage
      property params : LSP::TextDocumentPositionParams

      # Fallback handler for nil, obviously it should not happen.
      def hover(node : Nil, workspace) : Array(String)
        ["This should not happen! Please create an issue about this!"]
      end

      # Fallback handler for nodes that does not have a handler yet.
      def hover(node : Ast::Node, workspace) : Array(String)
        type =
          type_of(node, workspace)

        [
          "Type information for: #{node.class}\n",
          type,
        ].compact
      end

      # Returns the type information of a node from the workspace
      def type_of(node : Ast::Node, workspace)
        workspace
          .type_checker
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
          Workspace[uri.path.to_s]

        contents =
          if error = workspace.error
            # If the workspace has an error we cannot really
            # provide and hover information, so we just provide
            # the error instead.
            [
              "Cannot provide hover data because of an error:\n",
              "```\n#{error.to_terminal}\n```",
            ]
          else
            # We get the stack of nodes under the cursor
            stack =
              server.nodes_at_cursor(params)

            # stack.each do |item|
            #   print item.class.name.sub("Mint::Ast::", "")
            #   case item
            #   when Ast::Id, Ast::Variable
            #     print "(#{item.value})"
            #   end
            #   puts item.location.start
            # end

            node = stack[0]?
            parent = stack[1]?

            case node
            when Ast::Variable, Ast::Id
              # If the first node under the cursor is a `Ast::Variable`
              # or `Ast::Id`, then get the associated nodes
              # information and hover that otherwise get the hover
              # information of the parent.
              lookup =
                workspace.type_checker.variables[node]?

              if lookup
                case item = lookup[0]
                when Tuple(Ast::Node, Int32)
                  hover(item[0], workspace)
                when Ast::Node
                  hover(item, workspace)
                else
                  [item.to_s]
                end
              else
                hover(parent, workspace)
              end
            else
              hover(node, workspace)
            end
          end

        # Send the response.
        {contents: contents.compact}
      end
    end
  end
end
