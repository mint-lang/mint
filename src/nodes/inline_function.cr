class Ast
  class InlineFunction < Node
    getter body, arguments

    def initialize(@arguments : Array(Argument),
                   @body : Expression,
                   @input : Data,
                   @from : Int32,
                   @to : Int32)
    end
  end
end
