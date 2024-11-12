module Mint
  class Ast
    class FieldAccess < Node
      getter name, type

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @name : Variable,
                     @type : Type)
      end
    end
  end
end
