module Mint
  class Ast
    class Function < Node
      getter arguments, comment, name, type, body

      # TOOD: Remove when the old compiler is removed.
      property? keep_name = false

      def initialize(@arguments : Array(Argument),
                     @file : Parser::File,
                     @comment : Comment?,
                     @name : Variable,
                     @type : Node?,
                     @body : Block,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
