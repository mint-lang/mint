class Ast
  class RecordDefinition < Node
    getter fields, name

    def initialize(@fields : Array(RecordDefinitionField),
                   @name : String,
                   @input : Data,
                   @from : Int32,
                   @to : Int32)
    end
  end
end
