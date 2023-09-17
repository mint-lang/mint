module Mint
  class Ast
    class Locale < Node
      getter fields, comment, language

      def initialize(@fields : Array(RecordField),
                     @comment : Comment?,
                     @language : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
