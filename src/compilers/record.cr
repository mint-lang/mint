module Mint
  class Compiler
    def _compile(node : Ast::Record) : String
      fields =
        node.fields.each_with_object({} of String => String) do |field, memo|
          memo[field.key.value] = compile field.value
        end

      type =
        types[node]?

      if type
        name =
          js.class_of(type.name)

        "new #{name}(#{js.object(fields)})"
      else
        "new Record(#{js.object(fields)})"
      end
    end
  end
end
