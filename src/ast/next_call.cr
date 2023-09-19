module Mint
  class Ast
    class NextCall < Node
      getter data

      property entity : Ast::Node? = nil

      def initialize(@file : Parser::File,
                     @data : Record,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
