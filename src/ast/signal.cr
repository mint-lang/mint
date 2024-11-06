module Mint
  class Ast
    class Signal < Node
      getter block, comment, type, name

      def initialize(@file : Parser::File,
                     @comment : Comment?,
                     @name : Variable,
                     @block : Block,
                     @from : Int64,
                     @type : Type,
                     @to : Int64)
      end
    end
  end
end
