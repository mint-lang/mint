module Mint
  class Ast
    class HtmlStyle < Node
      getter name, arguments

      def initialize(@arguments : Array(Expression),
                     @name : Variable,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
