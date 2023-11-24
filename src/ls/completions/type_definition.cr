module Mint
  module LS
    class Completion < LSP::RequestMessage
      def completions(node : Ast::TypeDefinition) : Array(LSP::CompletionItem)
        case fields = node.fields
        when Array(Ast::TypeVariant)
          fields.map do |option|
            name =
              "#{node.name.value}.#{option.value.value}"

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
              documentation: option.comment.try(&.content).to_s,
              kind: LSP::CompletionItemKind::EnumMember,
              detail: "Type Option",
              insert_text: snippet,
              filter_text: name,
              sort_text: name,
              label: name)
          end
        else
          [] of LSP::CompletionItem
        end
      end
    end
  end
end
