module Mint
  class TypeChecker
    def here_doc_interpolation_type_mismatch(
      expected : Checkable,
      got : Checkable,
      node : Ast::Node
    )
      error :here_doc_interpolation_type_mismatch do
        block do
          text "An interpolation in here document is causing a mismatch."
        end

        snippet "The expected type is:", expected
        snippet "Instead it got:", got

        snippet "It is here:", node
      end
    end

    def check(node : Ast::HereDoc) : Checkable
      if node.modifier == '#'
        node.value.each do |item|
          case item
          when Ast::Node
            item_type =
              resolve item

            here_doc_interpolation_type_mismatch(
              expected: HTML,
              got: item_type,
              node: item,
            ) unless Comparer.matches_any?(item_type, [STRING, NUMBER, HTML])
          end
        end

        HTML
      else
        node.value.each do |item|
          case item
          when Ast::Node
            item_type =
              resolve item

            here_doc_interpolation_type_mismatch(
              expected: STRING,
              got: item_type,
              node: item,
            ) unless Comparer.matches_any?(item_type, [STRING, NUMBER])
          end
        end

        STRING
      end
    end
  end
end
