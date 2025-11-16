module Mint
  class TypeChecker
    def check(node : Ast::ArrayLiteral) : Checkable
      defined_type =
        node.type.try do |type|
          Type.new("Array", [resolve(type).as(Checkable)])
        end

      if node.items.empty?
        defined_type || Type.new("Array", [Variable.new("a").as(Checkable)])
      else
        first =
          resolve node.items.first

        unified =
          node
            .items[1..]
            .each_with_index
            .reduce([first]) do |resolved, (item, index)|
              type = resolve item

              succeeded = false
              item_type =
                resolved.map do |item|
                  next item if succeeded
                  if x = Comparer.compare(type, item)
                    succeeded = true
                    x
                  else
                    item
                  end
                end

              if succeeded
                resolved
              else
                resolved + [type]
              end
            end

        type =
          if unified.size == 1
            unified.first
          else
            Tags.new(unified, inferred: true)
          end

        inferred_type =
          Comparer.normalize(Type.new("Array", [type]))

        if defined_type
          final_type =
            Comparer.compare(inferred_type, defined_type)

          error! :array_not_matches_defined_type do
            block do
              text "The"
              bold "defined type"
              text "of an array does not match the type of its items."
            end

            expected defined_type, inferred_type
            snippet "The array in question is here:", node.type.not_nil!
          end unless final_type

          final_type
        else
          inferred_type
        end
      end
    end
  end
end
