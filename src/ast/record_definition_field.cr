module Mint
  class Ast
    class RecordDefinitionField < Node
      getter key, type, mapping

      def initialize(@mapping : StringLiteral?,
                     @key : Variable,
                     @input : Data,
                     @from : Int32,
                     @type : Type,
                     @to : Int32)
      end
    end
  end
end
