class Ast
  class Void < Node
    def initialize(@input : Data,
                   @from : Int32,
                   @to : Int32)
    end
  end
end
