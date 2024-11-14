module Mint
  class Ast
    class Env < Node
      getter name

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @name : String)
      end
    end
  end
end
