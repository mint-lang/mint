module Mint
  class Compiler
    def compile(node : Ast::CaseBranch, index : Int32) : String
      expression =
        compile node.expression

      if node.match
        match =
          compile node.match.not_nil!

        if index == 0
          <<-RESULT
          if (_compare(__condition, #{match})) {
            return #{expression}
          }
          RESULT
        else
          <<-RESULT
          else if (_compare(__condition, #{match})) {
            return #{expression}
          }
          RESULT
        end
      else
        <<-RESULT
        else {
          return #{expression}
        }
        RESULT
      end
    end
  end
end
