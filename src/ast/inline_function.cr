module Mint
  class Ast
    class InlineFunction < Node
      getter body, arguments, type

      def initialize(@arguments : Array(Argument),
                     @file : Parser::File,
                     @body : Block,
                     @from : Int64,
                     @type : Node?,
                     @to : Int64)
      end
    end
  end
end
