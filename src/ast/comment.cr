module Mint
  class Ast
    class Comment < Node
      getter content, type, next_comment

      enum Type
        Inline
        Block
      end

      def initialize(@from : Parser::Location,
                     @next_comment : Comment?,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @content : String,
                     @type : Type)
      end

      def block?
        type == Type::Block
      end
    end
  end
end
