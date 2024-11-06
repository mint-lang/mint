module Mint
  class TypeChecker
    def check(node : Ast::Map) : Checkable
      defined_type =
        node.types.try do |types|
          Type.new("Map", [
            resolve(types[0]),
            resolve(types[1]),
          ] of Checkable)
        end

      if node.fields.empty?
        defined_type || MAP
      else
        first =
          node.fields.first.try do |field|
            check! field
            {resolve(field.key), resolve(field.value)}
          end

        rest =
          node.fields[1..node.fields.size]

        rest.each_with_index do |item, index|
          type =
            item.try do |field|
              check! field
              {resolve(field.key), resolve(field.value)}
            end

          return error! :map_key_not_matches do
            block do
              text "The key of the"
              bold "#{ordinal(index + 2)} field"
              text "of a map does not match the type of the 1st fields key."
            end

            snippet "I was expecting the type of the 1st fields key:", first[0]
            snippet "Instead it is:", type[0]
            snippet "The item in question is here:", item
          end unless Comparer.compare(type[0], first[0])

          return error! :map_value_not_matches do
            block do
              text "The value of the"
              bold "#{ordinal(index + 2)} field"
              text "of a map does not match the type of the 1st fields value."
            end

            snippet "I was expecting the type of the 1st fields value:", first[1]
            snippet "Instead it is:", type[1]
            snippet "The item in question is here:", item
          end unless Comparer.compare(type[1], first[1])
        end

        inferred_type =
          Comparer.normalize(Type.new("Map", [first[0], first[1]]))

        if defined_type
          final_type =
            Comparer.compare(inferred_type, defined_type)

          error! :map_not_matches_defined_type do
            block do
              text "The"
              bold "defined type"
              text "of an map does not match the type of its fields."
            end

            expected defined_type, inferred_type
            snippet "The map in question is here:", node
          end unless final_type

          final_type
        else
          inferred_type
        end
      end
    end
  end
end
