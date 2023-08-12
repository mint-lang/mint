module Mint
  class TypeChecker
    def check(node : Ast::ArrayLiteral) : Checkable
      defined_type =
        node.type.try do |type|
          Type.new("Array", [resolve(type).as(Checkable)])
        end

      if node.items.empty?
        if defined_type
          defined_type
        else
          Type.new("Array", [Variable.new("a").as(Checkable)])
        end
      else
        first =
          resolve node.items.first

        rest =
          node.items[1..node.items.size]

        rest.each_with_index do |item, index|
          type = resolve item

          return error :array_not_matches do
            block do
              text "The"
              bold "#{ordinal(index + 2)} item"
              text "of an array does not match the type of the first item."
            end

            snippet "I was expecting the same type as of the first item:", first
            snippet "Instead it is:", type
            snippet "The item is here:", item
          end unless Comparer.compare(type, first)
        end

        inferred_type =
          Comparer.normalize(Type.new("Array", [first]))

        if defined_type
          final_type =
            Comparer.compare(inferred_type, defined_type)

          error :array_not_matches_defined_type do
            block do
              text "The"
              bold "defined type"
              text "of an array does not match the type of its items."
            end

            expected defined_type, inferred_type
            snippet node
          end unless final_type

          final_type
        else
          inferred_type
        end
      end
    end
  end
end
