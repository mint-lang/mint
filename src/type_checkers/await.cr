module Mint
  class TypeChecker
    def check(node : Ast::Await) : Checkable
      type =
        resolve node.body

      if block = self.block
        async.add(block)
      end

      case type.name
      when "Array"
        case type.parameters.first.name
        when "Promise", "Deferred"
          Type.new("Array", [type.parameters.first.parameters.first])
        end
      when "Promise", "Deferred"
        type.parameters.first
      end || type
    end
  end
end
