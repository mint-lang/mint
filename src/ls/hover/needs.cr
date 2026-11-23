module Mint
  module LS
    class Hover < LSP::RequestMessage
      # Returns the values a function, get or component needs (passed to it
      # implicitly from where it is used).
      def needs(
        node : Ast::Node,
        workspace : Workspace,
        type_checker : TypeChecker,
      ) : Array(String)
        needs =
          type_checker.artifacts.requirement_items[node]?

        return [] of String unless needs

        items =
          needs.keys.sort!.map do |name|
            "- `#{name} : #{workspace.format(needs[name].type)}`"
          end

        ["\n**Needs**\n", items.join("\n")]
      end
    end
  end
end
