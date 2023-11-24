module Mint
  class Ast
    class Defer < Node
      getter body

      def initialize(@file : Parser::File,
                     @from : Int64,
                     @body : Node,
                     @to : Int64)
      end
    end
  end
end
