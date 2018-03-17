class Ast
  class Access < Node
    getter fields

    def initialize(@fields : Array(Variable),
                   @input : Data,
                   @from : Int32,
                   @to : Int32)
    end
  end
end
