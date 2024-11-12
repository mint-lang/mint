module Mint
  class Ast
    class Map < Node
      getter fields, types

      def initialize(@types : Tuple(Ast::Node, Ast::Node)?,
                     @fields : Array(MapField),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File)
      end
    end
  end
end
