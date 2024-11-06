module Mint
  class Ast
    class TypeDefinitionField < Node
      getter mapping, comment, type, key

      def initialize(@mapping : StringLiteral?,
                     @file : Parser::File,
                     @comment : Comment?,
                     @key : Variable,
                     @from : Int64,
                     @type : Node,
                     @to : Int64)
      end
    end
  end
end
