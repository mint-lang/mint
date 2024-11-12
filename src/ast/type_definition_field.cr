module Mint
  class Ast
    class TypeDefinitionField < Node
      getter mapping, comment, type, key

      def initialize(@mapping : StringLiteral?,
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @comment : Comment?,
                     @key : Variable,
                     @type : Node)
      end
    end
  end
end
