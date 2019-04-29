module Mint
  class Ast
    class MemberAccess < Node
      getter name

      def initialize(@name : Variable,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
