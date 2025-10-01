module Mint
  class Ast
    module Directives
      class Size < Node
        getter ref

        def initialize(@from : Parser::Location,
                       @to : Parser::Location,
                       @file : Parser::File,
                       @ref : Variable)
        end
      end
    end
  end
end
