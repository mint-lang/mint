module Mint
  class Compiler
    def compile(
      node : Ast::Case,
      block : Proc(String, String)? = nil
    ) : Compiled
      compile node do
        condition =
          compile node.condition

        branches =
          node
            .branches
            .sort_by(&.pattern.nil?.to_s)
            .map { |branch| compile branch, block }

        js.call(Builtin::Match, [condition, js.array(branches)])
      end
    end
  end
end
