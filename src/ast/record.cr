module Mint
  class Ast
    class Record < Node
      getter fields

      def initialize(@fields : Array(Field),
                     @file : Parser::File,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
