module Mint
  class Ast
    class Use < Node
      getter provider, condition, data

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @condition : Node?,
                     @provider : Id,
                     @data : Record)
      end
    end
  end
end
