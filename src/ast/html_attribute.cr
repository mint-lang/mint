module Mint
  class Ast
    class HtmlAttribute < Node
      getter value, name

      delegate static?, to: @value

      def initialize(@value : Expression,
                     @name : Variable,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end

      def static_value : String
        "#{name.value}=#{value.static_value}"
      end
    end
  end
end
