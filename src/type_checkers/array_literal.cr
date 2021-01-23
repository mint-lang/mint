module Mint
  class TypeChecker
    type_error ArrayNotMatchesDefinedType
    type_error ArrayNotMatches

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

        node.items[1..node.items.size].each_with_index do |item, index|
          type = resolve item

          raise ArrayNotMatches, {
            "index"    => (index + 2).to_s,
            "expected" => first,
            "got"      => type,
            "node"     => item,
          } unless Comparer.compare(type, first)
        end

        inferred_type =
          Comparer.normalize(Type.new("Array", [first]))

        if defined_type
          final_type =
            Comparer.compare(inferred_type, defined_type)

          raise ArrayNotMatchesDefinedType, {
            "expected" => defined_type,
            "got"      => inferred_type,
            "node"     => node,
          } unless final_type

          final_type
        else
          inferred_type
        end
      end
    end
  end
end
