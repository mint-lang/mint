module Mint
  class Ast
    class TypeVariant < Node
      getter parameters, comment, value

      def initialize(@parameters : Array(Node) | Array(TypeDefinitionField),
                     @file : Parser::File,
                     @comment : Comment?,
                     @from : Int64,
                     @to : Int64,
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
