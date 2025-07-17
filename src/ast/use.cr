module Mint
  class Ast
    class Use < Node
      getter provider, condition, data

      property? context = false

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @condition : Node?,
                     @context : Bool,
                     @provider : Id,
                     @data : Record)
      end
    end
  end
end
