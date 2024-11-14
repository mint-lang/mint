module Mint
  class Ast
    module Directives
      class Highlight < Node
        getter content

        def initialize(@from : Parser::Location,
                       @to : Parser::Location,
                       @file : Parser::File,
                       @content : Block)
        end
      end
    end
  end
end
