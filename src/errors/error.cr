module Mint
  # This is the base class of an error, it uses a Message
  # to render to both to the Terminal and to an HTML format.
  class Error < Exception
    alias Value = String | Ast::Node | TypeChecker::Type |
                  Array(TypeChecker::Type) |
                  Array(String)

    alias Locals = Hash(String, Value)

    getter locals

    def initialize(@locals = Locals.new)
    end

    def to_terminal
      instance.to_terminal(80)
    end

    def to_html
      instance.to_html
    end

    def instance
      Message.new(@locals)
    end
  end
end
