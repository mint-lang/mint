module Mint
  class Compiler2
    def compile(node : Ast::Emit) : Compiled
      compile node do
        js.assign(Signal.new(node.signal.not_nil!), compile(node.expression))
      end
    end
  end
end
