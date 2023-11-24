module Mint
  class Compiler2
    def compile(node : Ast::Defer) : Compiled
      compile node do
        add(node, node, compile(node.body))

        [Deferred.new(node)] of Item
      end
    end

    def defer(node : Ast::Node, compiled : Compiled)
      case type = cache[node]
      when TypeChecker::Type
        if type.name == "Deferred"
          js.call(Builtin::Load, [compiled])
        end
      end || compiled
    end
  end
end
