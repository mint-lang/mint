module Mint
  class Ast
    class HtmlAttribute < Node
      getter value, name

      def initialize(@file : Parser::File,
                     @name : Variable,
                     @value : Node,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
