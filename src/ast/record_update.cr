module Mint
  class Ast
    class RecordUpdate < Node
      getter expression, fields

      def initialize(@from : Parser::Location,
                     @expression : Ast::Node,
                     @to : Parser::Location,
                     @fields : Array(Field),
                     @file : Parser::File)
      end
    end
  end
end
