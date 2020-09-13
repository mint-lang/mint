module Mint
  class Ast
    class EnumRecordDefinition < Node
      getter fields

      def initialize(@fields : Array(RecordDefinitionField),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
