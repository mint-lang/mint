module Mint
  class TypeChecker
    type_error ArrayNotMatches

    def check(node : Ast::ArrayLiteral) : Checkable
      if node.items.empty?
        Type.new("Array", [Variable.new("a").as(Checkable)])
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

        Comparer.normalize(Type.new("Array", [first]))
      end
    end
  end
end
