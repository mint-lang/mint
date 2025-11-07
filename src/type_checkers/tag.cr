module Mint
  class TypeChecker
    def check(node : Ast::Tag) : Checkable
      # TODO: Cache tags...
      Tag.new(node.value)
    end

    def check(node : Ast::Tags) : Checkable
      Tags.new(node.options.map(&.value))
    end
  end
end
