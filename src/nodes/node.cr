class Ast
  class Node
    getter input, from, to

    def initialize(@input : Data,
                   @from : Int32,
                   @to : Int32)
    end
  end
end
