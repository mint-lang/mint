module Mint
  class Ast
    class RecordUpdate < Node
      getter expression, fields

      def initialize(@expression : Ast::Node,
                     @fields : Array(Field),
                     @file : Parser::File,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
