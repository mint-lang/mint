module Mint
  class Compiler2
    def resolve(node : Ast::TypeDefinition)
      resolve node do
        case fields = node.fields
        when Array(Ast::TypeVariant)
          fields.map do |option|
            args =
              if (fields = option.fields) && !option.parameters.empty?
                [js.array(fields.map { |item| [%("#{item.key.value}")] of Item })]
              else
                [[option.parameters.size.to_s] of Item]
              end

            add node, option, js.call(Builtin::Variant, args)
          end
        end
      end
    end
  end
end
