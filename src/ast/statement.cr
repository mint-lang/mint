module Mint
  class Ast
    class Statement < Node
      property if_node : Ast::If? = nil

      getter expression, target, await

      def initialize(@file : Parser::File,
                     @expression : Node,
                     @target : Node?,
                     @await : Bool,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
