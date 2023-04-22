module Mint
  module LS
    class StackReader
      def initialize(@stack : Array(Ast::Node))
        @index = 0
      end

      def find_next(klass : N.class) : N | Nil forall N
        node = @stack[@index]?.try &.as?(N)
        @index += 1
        node
      end

      def find_anywhere(klass : N.class) : N | Nil forall N
        @stack[@index..].each do
          node = find_next(klass)
          return node if node
        end
      end
    end
  end
end
