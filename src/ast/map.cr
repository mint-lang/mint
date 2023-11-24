module Mint
  class Ast
    class Map < Node
      getter fields, types

      def initialize(@types : Tuple(Ast::Node, Ast::Node)?,
                     @fields : Array(MapField),
                     @file : Parser::File,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
