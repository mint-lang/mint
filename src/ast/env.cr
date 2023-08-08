module Mint
  class Ast
    class Env < Node
      getter name

      def initialize(@file : Parser::File,
                     @name : String,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
