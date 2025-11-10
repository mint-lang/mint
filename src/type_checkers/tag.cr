module Mint
  class TypeChecker
    def check(node : Ast::Tags) : Checkable
      Tags.new(node.options.map { |option| resolve(option) })
    end
  end
end
