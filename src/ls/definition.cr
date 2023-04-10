module Mint
  module LS
    # This is the class that handles the "textDocument/definition" request.
    class Definition < LSP::RequestMessage
      property params : LSP::TextDocumentPositionParams

      def execute(server) : LSP::LocationLink | Nil
        # Get the URI of the text document
        uri =
          URI.parse(params.text_document.uri)

        # Get the workspace associated with the text document
        # this could take a while because the workspace parses
        # and type checks all of its source files.
        workspace =
          Workspace[uri.path.to_s]

        contents =
          unless workspace.error
            # We get the stack of nodes under the cursor
            stack =
              server.nodes_at_cursor(params)

            #server.debug_stack(stack)

            html_style(server, workspace, stack) ||
              html_attribute(server, workspace, stack) ||
              html_component(server, workspace, stack)
          end

        contents
      end

      # Generates a LSP::LocationLink that links from source to the target node
      def location_link(source : Ast::Node, target : Ast::Node) : LSP::LocationLink
        return LSP::LocationLink.new(
          origin_selection_range: selection(source),
          target_uri: "file://#{target.location.filename}",
          target_range: selection_all(target),
          target_selection_range: selection(target)
        )
      end

      def definition(variable : Ast::Variable, connect_variable : Ast::ConnectVariable, connect : Ast::Connect, workspace : Workspace) : LSP::LocationLink | Nil
        store =
          workspace.ast.stores.find { |store| store.name }

        if store
          variable_name = connect_variable.variable.value

          target =
            store.functions.find { |function| function.name.value == variable_name } ||
              store.constants.find { |constant| constant.name == variable_name } ||
              store.states.find { |state| state.name.value == variable_name } ||
              store.gets.find { |get| get.name.value == variable_name }

          if target
            target_range =
              case target
              when Ast::Function
                selection_all(target)
              when Ast::Constant
                selection_all(target)
              when Ast::State
                selection_all(target)
              when Ast::Get
                selection_all(target)
              end

            target_selection_range =
              case target
              when Ast::Function
                selection(target)
              when Ast::Constant
                selection(target)
              when Ast::State
                selection(target)
              when Ast::Get
                selection(target)
              end

            if target_range
              LSP::LocationLink.new(
                origin_selection_range: selection(connect_variable),
                target_uri: "file://#{store.location.filename}",
                target_range: target_range,
                target_selection_range: target_range # This shouldn't include comments etc
              )
            end
          end
        end
      end
    end
  end
end
