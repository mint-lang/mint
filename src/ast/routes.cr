module Mint
  class Ast
    class Routes < Node
      getter comments, routes

      def initialize(@comments : Array(Comment),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @routes : Array(Route),
                     @file : Parser::File)
      end
    end
  end
end
