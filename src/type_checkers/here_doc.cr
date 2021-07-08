module Mint
  class TypeChecker
    type_error HereDocInterpolationTypeMismatch

    def check(node : Ast::HereDoc) : Checkable
      if node.modifier == '#'
        node.value.each do |item|
          case item
          when Ast::Node
            item_type =
              resolve item

            raise HereDocInterpolationTypeMismatch, {
              "expected" => HTML,
              "got"      => item_type,
              "node"     => item,
            } unless Comparer.matches_any?(item_type, [STRING, NUMBER, HTML])
          end
        end

        HTML
      else
        node.value.each do |item|
          case item
          when Ast::Node
            item_type =
              resolve item

            raise HereDocInterpolationTypeMismatch, {
              "expected" => STRING,
              "got"      => item_type,
              "node"     => item,
            } unless Comparer.matches_any?(item_type, [STRING, NUMBER])
          end
        end

        STRING
      end
    end
  end
end
