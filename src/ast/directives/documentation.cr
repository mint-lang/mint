module Mint
  class Ast
    module Directives
      class Documentation < Node
        getter entity

        def initialize(@entity : String,
                       @input : Data,
                       @from : Int32,
                       @to : Int32)
        end
      end
    end
  end
end
