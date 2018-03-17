class TypeChecker
  type_error ArrayNotMatches

  def check(node : Ast::ArrayLiteral) : Type
    if node.items.empty?
      Type.new("Array", [Type.new("a")])
    else
      first =
        check node.items.first

      node.items[1..node.items.size].each_with_index do |item, index|
        type = check item

        raise ArrayNotMatches, {
          "index"    => index + 1,
          "expected" => first,
          "got"      => type,
          "node"     => item,
        } unless Comparer.compare(type, first)
      end

      Type.new("Array", [first])
    end
  end
end
