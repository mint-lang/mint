module Mint
  class Ast
    class HtmlFragment < Node
      getter comments, children, tag

      def initialize(@comments : Array(Comment),
                     @children : Array(Node),
                     @file : Parser::File,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
