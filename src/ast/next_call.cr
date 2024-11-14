module Mint
  class Ast
    class NextCall < Node
      getter data

      property entity : Ast::Node? = nil

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @data : Record)
      end
    end
  end
end
