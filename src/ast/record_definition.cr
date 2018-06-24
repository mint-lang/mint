module Mint
  class Ast
    class RecordDefinition < Node
      getter fields, name, comment

      def initialize(@fields : Array(RecordDefinitionField),
                     @comment : Comment?,
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
