module Mint
  class Ast
    class ReturnCall < Node
      property statement : Ast::Statement? = nil

      getter expression

      def initialize(@file : Parser::File,
                     @expression : Node,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
