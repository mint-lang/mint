module Mint
  class TypeChecker
    def check(node : Ast::Js) : Checkable
      node.value.each do |item|
        case item
        when Ast::Node
          resolve item
        end
      end

      node.type.try { |type| resolve type } || Variable.new("a")
    end
  end
end
