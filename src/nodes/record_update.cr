class Ast
  class RecordUpdate < Node
    getter fields, variable

    def initialize(@fields : Array(RecordField),
                   @variable : Variable,
                   @input : Data,
                   @from : Int32,
                   @to : Int32)
    end
  end
end
