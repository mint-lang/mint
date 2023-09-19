module Mint
  class Ast
    class MemberAccess < Node
      getter name

      def initialize(@file : Parser::File,
                     @name : Variable,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
