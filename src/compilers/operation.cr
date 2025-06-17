module Mint
  class Compiler
    def compile(node : Ast::Operation) : Compiled
      compile node do
        left =
          compile node.left

        case node.left
        when Ast::HtmlComponent
          left
        else
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
end
