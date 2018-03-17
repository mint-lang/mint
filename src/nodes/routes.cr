class Ast
  class Routes < Node
    getter routes

    def initialize(@routes : Array(Route),
                   @input : Data,
                   @from : Int32,
                   @to : Int32)
    end
  end
end
