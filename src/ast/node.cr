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

      def owns?(node)
        false
      end

      def static?
        false
      end

      def static_value
        ""
      end

      def source
        input.input[from, to - from]
      end

      def new_line?
        source.strip.includes?('\n')
      end
    end
  end
end
