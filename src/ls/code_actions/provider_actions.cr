module Mint
  module LS
    class CodeAction < LSP::RequestMessage
      module ProviderActions
        extend self

        def order_entities(node, workspace, uri)
          # Save the original order of constants and functions
          order =
            (node.functions + node.constants + node.states + node.gets)
              .sort_by!(&.from)
              .map(&.from)

          # Reorder by name and the appropriate order from the original order
          (node.states.sort_by(&.name.value) +
            node.constants.sort_by(&.name) +
            node.gets.sort_by(&.name.value) +
            node.functions.sort_by(&.name.value))
            .each_with_index { |entity, index| entity.from = order[index] }

          # This should not fail since we return on errors earlier
          formatted =
            workspace.format(URI.parse(uri).path.to_s)

          # Create a workspace edit of the formatted document
          edit =
            LSP::WorkspaceEdit.new({
              uri => [
                LSP::TextEdit.new(new_text: formatted, range: LSP::Range.new(
                  start: LSP::Position.new(line: 0, character: 0),
                  end: LSP::Position.new(line: 9999, character: 999)
                )),
              ],
            })

          LSP::CodeAction.new(
            title: "Order Entities",
            kind: "source",
            edit: edit)
        end
      end
    end
  end
end
