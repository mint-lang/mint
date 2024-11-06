module Mint
  class TypeChecker
    def check(node : Ast::Await) : Checkable
      type =
        resolve node.body

      if block = self.block
        async.add(block)
      end

      case type.name
      when "Promise", "Deferred"
        type.parameters.first
      else
        type
      end
    end
  end
end
