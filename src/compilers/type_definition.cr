module Mint
  class Compiler
    def resolve(node : Ast::TypeDefinition)
      resolve node do
        case fields = node.fields
        when Array(Ast::TypeVariant)
          fields.map do |option|
            name =
              js.string("#{node.name.value}.#{option.value.value}")

            args =
              if (fields = option.fields) && !option.parameters.empty?
                [
                  js.array(fields.map { |item| [%("#{item.key.value}")] of Item }),
                  name,
                ]
              else
                [
                  [option.parameters.size.to_s] of Item,
                  name,
                ]
              end

            # add node, option, js.call(Builtin::Variant, args)
            tag(node, cache[option])
          end
        end

        if context = node.context
          add(node, Context.new(node),
            js.call(Builtin::CreateContext, [compile(context)]))
        end
      end
    end
  end
end
