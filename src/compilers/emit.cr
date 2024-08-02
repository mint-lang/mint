module Mint
  class Compiler
    def compile(node : Ast::Emit) : Compiled
      compile node do
        js.assign(Signal.new(node.signal.not_nil!), compile(node.expression))
      end
    end
  end
end
