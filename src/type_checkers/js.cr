module Mint
  class TypeChecker
    def check(node : Ast::Js) : Checkable
      node.value.each do |item|
        case item
        when Ast::Node
          resolve item
        end
      end

      JS
    end
  end
end
