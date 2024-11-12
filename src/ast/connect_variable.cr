module Mint
  class Ast
    class ConnectVariable < Node
      getter target, name

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @target : Variable?,
                     @name : Variable)
      end
    end
  end
end
