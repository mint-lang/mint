module Mint
  class Ast
    class TypeDefinition < Node
      getter name, fields, parameters, comment

      def initialize(@fields : Array(TypeDefinitionField) | Array(Ast::TypeVariant),
                     @parameters : Array(TypeVariable),
                     @file : Parser::File,
                     @comment : Comment?,
                     @from : Int64,
                     @to : Int64,
                     @name : Id)
      end
    end
  end
end
