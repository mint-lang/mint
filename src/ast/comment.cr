module Mint
  class Ast
    # TODO: Allow multiple comments in this node instead of a single one.
    class Comment < Node
      enum Type
        Inline
        Block
      end

      getter content, type

      def initialize(@file : Parser::File,
                     @content : String,
                     @from : Int64,
                     @type : Type,
                     @to : Int64)
      end

      def to_html
        Markd.to_html(content)
      end
    end
  end
end
