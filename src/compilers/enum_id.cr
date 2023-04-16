module Mint
  class Compiler
    def _compile(node : Ast::EnumId) : String
      case parent = lookups[node]?
      when Ast::Variable
        compile(parent)
      when nil
        type =
          types[node]?

        case type
        when TypeChecker::Record
          name =
            js.class_of(type.name)

          args = %w[]

          fields =
            type
              .fields
              .each_with_index
              .reduce({} of String => String) do |memo, value|
                field, index = value
                key, _ = field

                memo[key] =
                  if item = node.expressions[index]?
                    compile(item)
                  else
                    arg = "_#{args.size}"
                    args << arg
                    arg
                  end

                memo
              end

          body =
            "new #{name}(#{js.object(fields)})"

          if args.empty?
            body
          else
            js.arrow_function(args, js.return(body))
          end
        else
          ""
        end
      else
        name =
          js.class_of(parent)

        expressions =
          compile node.expressions, ","

        "new #{name}(#{expressions})"
      end
    end
  end
end
