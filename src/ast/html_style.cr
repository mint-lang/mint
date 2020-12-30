module Mint
  class Ast
    class HtmlStyle < Node
      getter name, arguments, entity

      def initialize(@arguments : Array(Expression),
                     @entity : String?,
                     @name : Variable,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
