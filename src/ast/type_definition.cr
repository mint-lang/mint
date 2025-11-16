module Mint
  class Ast
    class TypeDefinition < Node
      getter parameters, end_comment, comment, fields, name, context

      def initialize(@fields : Array(TypeDefinitionField) | Array(TypeVariant),
                     @parameters : Array(TypeVariable),
                     @from : Parser::Location,
                     @end_comment : Comment?,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @comment : Comment?,
                     @context : Node?,
                     @name : Id)
      end

      def variant?(name : String) : TypeVariant?
        case items = fields
        when Array(TypeVariant)
          items.find(&.value.value.==(name))
        end
      end
    end
  end
end
