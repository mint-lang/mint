module Mint
  class Ast
    class Use < Node
      getter provider, condition, data

      def initialize(@file : Parser::File,
                     @condition : Node?,
                     @provider : Id,
                     @data : Record,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
