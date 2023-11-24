module Mint
  class Ast
    class State < Node
      getter default, comment, type, name

      def initialize(@file : Parser::File,
                     @comment : Comment?,
                     @name : Variable,
                     @default : Node,
                     @from : Int64,
                     @type : Type?,
                     @to : Int64)
      end
    end
  end
end
