module Mint
  class Ast
    class Provide < Node
      getter fields, body

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @fields : Array(Field),
                     @body : Block)
      end

      def names : Array(String)
        fields.compact_map(&.key.try(&.value))
      end
    end
  end
end
