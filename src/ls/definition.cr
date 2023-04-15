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

      def selection(node : Ast::Component) : LSP::Range
        # Select only the name part of the component
        #   global component MintComponent {
        #                    ^^^^^^^^^^^^^

        start_line, start_column = node.location.start

        # TODO: Change parser so component name is a node?
        offset = if node.global?
                   "global component ".size
                 else
                   "component ".size
                 end

        location = Ast::Node::Location.new(
          filename: node.location.filename,
          start: {start_line, start_column + offset},
          end: {start_line, start_column + offset + node.name.size}
        )

        selection(location)
      end

      def selection(node : Ast::HtmlAttribute) : LSP::Range
        # Select only the name part of the attribute
        # <Component attribute={value}>
        #            ^^^^^^^^^
        selection(node.name)
      end

      def selection(node : Ast::HtmlComponent) : LSP::Range
        # Select only the name part of the component
        # <Component attribute={value}>
        #  ^^^^^^^^^
        selection(node.component)
      end

      def selection(node : Ast::HtmlStyle) : LSP::Range
        # Select only the name part of the component
        #   <div::style>
        #         ^^^^^

        start_line, start_column = node.location.start

        # Skip the first two characters "::"
        location = Ast::Node::Location.new(
          filename: node.location.filename,
          start: {start_line, start_column + 2},
          end: node.location.end
        )

        selection(location)
      end

      def selection(node : Ast::Property) : LSP::Range
        # Select only the name part of the property
        #     property size : String = "small"
        #              ^^^^
        selection(node.name)
      end

      def selection(node : Ast::Style) : LSP::Range
        # Select only the name part of the style
        #     style app {
        #           ^^^
        selection(node.name)
      end

      # Generates a LSP::LocationLink that links from source to the target node
      def location_link(source : Ast::Node, target : Ast::Node) : LSP::LocationLink
        return LSP::LocationLink.new(
          origin_selection_range: selection(source),
          target_uri: "file://#{target.location.filename}",
          target_range: selection(target.location),
          target_selection_range: selection(target)
        )
      end
    end
  end
end
