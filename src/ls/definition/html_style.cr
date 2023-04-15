module Mint
  module LS
    class Definition < LSP::RequestMessage \
        # Attempts to find the linked style block
      #
      # <div::first::second />
      #       ^^^^^
      def html_style(server : Server, workspace : Workspace, stack : Array(Ast::Node))
        return unless variable =
                        next_variable stack
        return unless html_style =
                        next_html_style stack
        return unless component =
                        any_component stack

        return unless component_style = component.styles.find { |x| x.name.value == variable.value }

        location_link variable, component_style
      end
    end
  end
end
