module Mint
  class Ast
    module Directives
      class Format < Node
        getter content

        def initialize(@content : Block,
                       @input : Data,
                       @from : Int32,
                       @to : Int32)
        end
      end
    end
  end
end
