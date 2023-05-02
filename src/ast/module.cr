module Mint
  class Ast
    class Module < Node
      getter name, functions, comment, comments, constants

      def initialize(@functions : Array(Function),
                     @constants : Array(Constant),
                     @comments : Array(Comment),
                     @comment : Comment?,
                     @name : TypeId,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
