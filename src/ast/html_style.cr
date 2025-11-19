module Mint
  class Ast
    class HtmlStyle < Node
      getter arguments, name

      property style_node : Ast::Style? = nil

      def initialize(@arguments : Array(Field),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @name : Variable)
      end

      # NOTE: This is here to provide compatibility for calls (functions)...
      def await
        nil
      end
    end
  end
end
