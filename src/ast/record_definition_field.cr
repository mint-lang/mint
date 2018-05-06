module Mint
  class Ast
    class RecordDefinitionField < Node
      getter key, type

      def initialize(@key : Variable,
                     @input : Data,
                     @from : Int32,
                     @type : Type,
                     @to : Int32)
      end
    end
  end
end
