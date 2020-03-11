module Mint
  class Ast
    class Node
      getter input, from, to

      def initialize(@input : Data,
                     @from : Int32,
                     @to : Int32)
      end

      def to_tuple
        {input: input, from: from, to: to}
      end

      def static?
        false
      end

      def static_value
        ""
      end

      def has_new_line?
        input.input[from, to - from].includes?("\n")
      end
    end
  end
end
