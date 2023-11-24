module Mint
  class Ast
    class HtmlStyle < Node
      getter arguments, name

      property style_node : Ast::Style? = nil

      def initialize(@arguments : Array(Field),
                     @file : Parser::File,
                     @name : Variable,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
