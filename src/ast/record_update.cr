module Mint
  class Ast
    class RecordUpdate < Node
      getter expression, fields, comment

      def initialize(@from : Parser::Location,
                     @expression : Ast::Node,
                     @to : Parser::Location,
                     @fields : Array(Field),
                     @file : Parser::File,
                     @comment : Comment?)
      end
    end
  end
end
