module Mint
  class Ast
    class Routes < Node
      getter routes, comments

      def initialize(@comments : Array(Comment),
                     @routes : Array(Route),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
