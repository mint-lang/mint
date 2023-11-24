module Mint
  class Ast
    class Comment < Node
      enum Type
        Inline
        Block
      end

      getter content, type, next_comment

      def initialize(@next_comment : Comment?,
                     @file : Parser::File,
                     @content : String,
                     @from : Int64,
                     @type : Type,
                     @to : Int64)
      end

      def block?
        type == Type::Block
      end

      def to_html
        Markd.to_html(content)
      end
    end
  end
end
