module Mint
  module LS
    # This is the class that handles the "textDocument/hover" request.
    class Definition < LSP::RequestMessage
      property params : LSP::TextDocumentPositionParams

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
            # the error istead.
            [
              "Cannot provide hover data because of an error:\n",
              "```\n#{error.to_terminal}\n```",
            ]
          else
            # We get the stack of nodes under the cursor
            stack =
              server.nodes_at_cursor(params)

            server.debug_stack(stack)

            server.log(workspace.ast.nodes.map { |node| "#{node.to_s} #{node.class.name}" }.join(",\n"))

            first = stack[0]?
            second = stack[1]?
            third = stack[2]?

            case first
            when Ast::Variable
              case second
              when Ast::HtmlAttribute
                case third
                when Ast::HtmlComponent
                  # <Component property={value} />
                  #            ^^^^^^^^
                  return definition(first, second, third, workspace)
                end
              when Ast::ConnectVariable
                case third
                when Ast::Connect
                  return definition(first, second, third, workspace)
                end
              end
            end

            case first
            when Ast::HtmlComponent
              # <Component property={value} />
              #  ^^^^^^^^^
              return definition(first, workspace)
            end

            [
              "Not handling this yet\n",
            ]
          end

        contents
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

      def definition(variable : Ast::Variable, html_attribute : Ast::HtmlAttribute, html_component : Ast::HtmlComponent, workspace : Workspace) : LSP::LocationLink | Nil
        component =
          workspace
            .type_checker
            .lookups[html_component]?

        case component
        when Ast::Component
          property = component.properties.find { |property| property.name.value == variable.value }

          if property
            LSP::LocationLink.new(
              origin_selection_range: selection(html_attribute),
              target_uri: "file://#{component.location.filename}",
              target_range: selection_all(property),
              target_selection_range: selection(property) # This shouldn't include comments etc
            )
          end
        end
      end

      def definition(node : Ast::HtmlComponent, workspace : Workspace) : LSP::LocationLink | Nil
        component =
          workspace
            .type_checker
            .lookups[node]?

        case component
        when Ast::Component
          LSP::LocationLink.new(
            origin_selection_range: selection(node),
            target_uri: "file://#{component.location.filename}",
            target_range: selection_all(component),
            target_selection_range: selection(component) # This shouldn't include comments etc
          )
        end
      end
    end
  end
end
