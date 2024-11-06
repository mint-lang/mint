module Mint
  class Ast
    class StateSetter < Node
      getter entity, state

      def initialize(@file : Parser::File,
                     @state : Variable,
                     @from : Int64,
                     @entity : Id?,
                     @to : Int64)
      end
    end
  end
end
