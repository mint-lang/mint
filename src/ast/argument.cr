module Mint
  class Ast
    class Argument < Node
      getter type, name, default

      def initialize(@file : Parser::File,
                     @default : Node?,
                     @name : Variable,
                     @from : Int64,
                     @type : Node,
                     @to : Int64)
      end
    end
  end
end
