module Mint
  class TypeChecker
    def check(node : Ast::SignalValue) : Checkable
      type =
        resolve node.expression

      error! :signal_value_not_signal do
        snippet "A signal value extractor only works on signals."
        snippet "The type of the value is:", type
        snippet "The expression in question is here:", node
      end unless Comparer.compare(SIGNAL, type)

      type.parameters.first
    end
  end
end
