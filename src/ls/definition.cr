module Mint
  module LS
    # This is the class that handles the "textDocument/definition" request.
    class Definition < LSP::RequestMessage
      property params : LSP::TextDocumentPositionParams

      def execute(server) : LSP::LocationLink | Nil
        uri =
          URI.parse(params.text_document.uri)

        workspace =
          Workspace[uri.path.to_s]

        unless workspace.error
          stack =
            server.nodes_at_cursor(params)
          
          html_style(server, workspace, stack.dup) ||
            html_attribute(server, workspace, stack.dup) ||
            html_component(server, workspace, stack.dup)
        end
      end

      {% for cls in Ast::Node.subclasses %}
        {% name = cls.name.split("::")[2..].join("").underscore.id %}
        def next_{{name}}(stack : Array(Ast::Node)) : {{ cls.name }} | Nil
          stack.shift?.try &.as?({{cls}})
        end

        def any_{{name}}(stack : Array(Ast::Node)) : {{ cls.name }} | Nil
          while node = stack.shift?
            if node.is_a?({{cls}})
              return node
            end            
          end
        end
      {% end %}

      # Generates a LSP::LocationLink that links from source to the target node
      def location_link(source : Ast::Node, target : Ast::Node) : LSP::LocationLink
        return LSP::LocationLink.new(
          origin_selection_range: selection(source),
          target_uri: "file://#{target.location.filename}",
          target_range: selection_all(target),
          target_selection_range: selection(target)
        )
      end
    end
  end
end
