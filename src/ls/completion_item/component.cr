module Mint
  module LS
    class Completion < LSP::RequestMessage
      def completion_item(node : Ast::Component) : LSP::CompletionItem
        index = 0

        attributes =
          node
            .properties
            .reject(&.name.value.==("children"))
            .map do |property|
              default =
                Mint::Formatter
                  .new(workspace.json.formatter)
                  .format!(property.default)
                  .to_s
                  .gsub("}", "\\}")

              type =
                workspace.type_checker.cache[property]?

              value =
                case type.try(&.name)
                when "String"
                  if default == %("")
                    %("${#{index + 2}}")
                  else
                    %(${#{index + 2}:#{default}})
                  end
                when "Array"
                  %([${#{index + 2}}])
                else
                  %({${#{index + 2}:#{default}}\\})
                end

              result =
                "${#{index + 1}:#{property.name.value}=#{value}}"

              index += 2

              result
            end

        snippet =
          case attributes.size
          when .> 3
            <<-MINT
            <#{node.name.value}
              #{attributes.join("\n  ")}>
              $0
            </#{node.name.value}>
            MINT
          when .> 0
            <<-MINT
            <#{node.name.value} #{attributes.join(" ")}>
              $0
            </#{node.name.value}>
            MINT
          else
            <<-MINT
            <#{node.name.value}>
              $0
            </#{node.name.value}>
            MINT
          end

        LSP::CompletionItem.new(
          kind: LSP::CompletionItemKind::Snippet,
          filter_text: node.name.value,
          sort_text: node.name.value,
          insert_text: snippet,
          detail: "Component",
          label: node.name.value)
      end
    end
  end
end
