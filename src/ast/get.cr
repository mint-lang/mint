module Mint
  class Ast
    class Get < Node
      getter comment, name, body, type

      def initialize(@file : Parser::File,
                     @comment : Comment?,
                     @name : Variable,
                     @body : Block,
                     @from : Int64,
                     @type : Node?,
                     @to : Int64)
      end
    end
  end
end
