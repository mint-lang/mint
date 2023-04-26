module Mint
  module LS
    class StackReader
      def initialize(@stack : Array(Ast::Node))
        @index = 0
      end

      def find_next(klass : N.class) : N? forall N
        @stack[@index]?.as?(N).tap do
          @index += 1
        end
      end

      def find_anywhere(klass : N.class) : N? forall N
        @stack[@index..].each do
          node = find_next(klass)
          return node if node
        end
      end
    end
  end
end
