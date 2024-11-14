module Mint
  class Ast
    class TypeDefinition < Node
      getter parameters, comment, fields, name

      def initialize(@fields : Array(TypeDefinitionField) | Array(TypeVariant),
                     @parameters : Array(TypeVariable),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @comment : Comment?,
                     @name : Id)
      end
    end
  end
end
