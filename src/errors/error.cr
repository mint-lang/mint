module Mint
  # This is the base class of an error, it uses a Message
  # to render to both to the Terminal and to an HTML format.
  class Error < Exception
    alias Value = String | Ast::Node | TypeChecker::Checkable |
                  Array(TypeChecker::Checkable) | Tuple(Ast::Node, Int32 | Array(Int32)) |
                  Array(String)

    alias Locals = Hash(String, Value)

    getter locals : Locals
    getter instance : Message { Message.new(locals) }

    def initialize(@locals = Locals.new)
    end

    def to_html
      instance.to_html
    end

    def to_terminal
      instance.to_terminal(80)
    end

    def message
      to_terminal.to_s
    end
  end
end
