module Mint
  class TypeChecker
    def here_doc_interpolation_type_mismatch(
      type : Checkable,
      got : Checkable,
      node : Ast::Node
    )
      error! :here_doc_interpolation_type_mismatch do
        block "An interpolation in here document is causing a mismatch."
        expected type, got
        snippet "The interpolation in question is here:", node
      end
    end

    def check(node : Ast::HereDocument) : Checkable
      if node.modifier == '#'
        node.value.each do |item|
          case item
          when Ast::Node
            item_type =
              resolve item

            here_doc_interpolation_type_mismatch(
              type: HTML,
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
              type: STRING,
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
