module Mint
  class Ast
    class HtmlAttribute < Node
      getter value, name

      def initialize(@value : Expression,
                     @name : Variable,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
