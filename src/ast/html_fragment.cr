module Mint
  class Ast
    class HtmlFragment < Node
      getter comments, children, tag

      def initialize(@comments : Array(Comment),
                     @from : Parser::Location,
                     @children : Array(Node),
                     @to : Parser::Location,
                     @file : Parser::File)
      end
    end
  end
end
