module Mint
  class Compiler
    def resolve(node : Ast::TypeDefinition)
      resolve node do
        case fields = node.fields
        when Array(Ast::TypeVariant)
          fields.map do |option|
            tag(option, cache[option])
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
