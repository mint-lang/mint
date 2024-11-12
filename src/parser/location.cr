module Mint
  class Parser
    # Offset (from the start of the file), line and column.
    record Location, offset : Int64, line : Int64, column : Int64 do
      def initialize
        @offset = 0
        @column = 0
        @line = 1
      end

      def -(other : Int64) : Location
        Location.new(
          offset: offset - other,
          column: column - other,
          line: line)
      end

      def +(other : Int64) : Location
        Location.new(
          offset: offset + other,
          column: column + other,
          line: line)
      end

      def to_tuple
        {offset, line, column}
      end
    end
  end
end
