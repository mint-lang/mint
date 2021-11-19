module Mint
  module LS
    class Completion < LSP::RequestMessage
      def completions(node : Ast::Enum) : Array(LSP::CompletionItem)
        node.options.map do |option|
          name =
            "#{node.name}::#{option.value}"

          snippet =
            if option.parameters.empty?
              name
            else
              parameters =
                option
                  .parameters
                  .map_with_index do |variable, index|
                    case variable
                    when Ast::TypeVariable
                      %(${#{index + 1}:#{variable.value}})
                    else
                      %(${#{index + 1})
                    end
                  end

              <<-MINT
              #{name}(#{parameters.join(", ")})
              MINT
            end

          LSP::CompletionItem.new(
            documentation: option.comment.try(&.value).to_s,
            kind: LSP::CompletionItemKind::EnumMember,
            detail: "Enum Option",
            insert_text: snippet,
            filter_text: name,
            sort_text: name,
            label: name)
        end
      end
    end
  end
end
