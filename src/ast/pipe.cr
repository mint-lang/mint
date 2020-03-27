module Mint
  class Ast
    class Pipe < Node
      getter expression, argument

      def initialize(@expression : Expression,
                     @argument : Expression,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end

      def call
        @call ||= Ast::Call.new(
          partially_applied: false,
          expression: expression,
          arguments: [argument],
          safe: false,
          input: input,
          from: from,
          to: to)
      end
    end
  end
end
