module Mint
  class Ast
    class Node
      property from : Parser::Location
      property parent : Node?

      getter to : Parser::Location
      getter file : Parser::File

      @source : String?

      def initialize(@file, @from, @to)
      end

      def contains?(line : Int64)
        from.line <= line <= to.line
      end

      def contains?(line : Int64, column : Int64)
        case
        when line == from.line == to.line # If on the only line
          from.column <= column < to.column
        when line == from.line # If on the first line
          column >= from.column
        when line == to.line # If on the last line
          column < to.column
        else
          contains?(line)
        end
      end

      def new_line?
        to.line > from.line
      end

      getter source : String do
        file.contents[from.offset, to.offset - from.offset]
      end
    end
  end
end
