module Mint
  class Ast
    module Directives
      class Documentation < Node
        getter entity

        def initialize(@file : Parser::File,
                       @from : Int64,
                       @entity : Id,
                       @to : Int64)
        end
      end
    end
  end
end
