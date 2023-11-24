module Mint
  class Compiler2
    def compile(node : Ast::Operation) : Compiled
      compile node do
        left =
          compile node.left

        right =
          compile node.right

        case node.operator
        when "or"
          js.call(Builtin::Or, [nothing, err, left, right])
        when "=="
          js.call(Builtin::Compare, [left, right])
        when "!="
          ["!"] + js.call(Builtin::Compare, [left, right])
        else
          left + [" #{node.operator} "] + right
        end
      end
    end
  end
end
