module Mint
  class Ast
    class Routes < Node
      getter routes, comments

      def initialize(@comments : Array(Comment),
                     @routes : Array(Route),
                     @file : Parser::File,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
