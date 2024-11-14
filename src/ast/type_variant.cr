module Mint
  class Ast
    class TypeVariant < Node
      getter parameters, comment, value

      def initialize(@parameters : Array(Node),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @comment : Comment?,
                     @value : Id)
      end

      def fields : Array(TypeDefinitionField)?
        if @parameters.all?(Ast::TypeDefinitionField)
          parameters.select(Ast::TypeDefinitionField)
        end
      end
    end
  end
end
