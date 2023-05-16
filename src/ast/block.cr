module Mint
  class Ast
    class Block < Node
      getter statements

      def initialize(@statements : Array(Node),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end

      def async?
        statements.select(Ast::Statement).any?(&.await)
      end

      def static?
        statements.all?(&.static?)
      end
    end
  end
end
