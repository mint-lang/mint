module Mint
  class Ast
    class Test < Node
      getter expression, name

      def initialize(@name : StringLiteral,
                     @file : Parser::File,
                     @expression : Block,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
