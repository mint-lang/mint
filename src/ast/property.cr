module Mint
  class Ast
    class Property < Node
      getter name, default, type, comment

      def initialize(@file : Parser::File,
                     @comment : Comment?,
                     @default : Node?,
                     @name : Variable,
                     @from : Int64,
                     @type : Type?,
                     @to : Int64)
      end
    end
  end
end
