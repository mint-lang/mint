module Mint
  class Compiler
    def _compile(node : Ast::RecordConstructor) : String
      type =
        types[node]?

      case type
      when TypeChecker::Record
        name =
          js.class_of(type.name)

        args = [] of String

        fields =
          type
            .fields
            .each_with_index
            .reduce({} of String => String) do |memo, value|
              field, index = value
              key, _ = field

              memo[key] =
                if item = node.arguments[index]?
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
    end
  end
end
