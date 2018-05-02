module Mint
  alias ErrorValue = String | Ast::Node | TypeChecker::Type |
                     Array(TypeChecker::Type) | Array(String)

  # This is the base class of an error, it uses a Message
  # to render to both to the Terminal and to an HTML format.
  class Error < Exception
    getter locals

    def initialize(@locals = Hash(String, ErrorValue).new)
    end

    def to_terminal
      instance.to_terminal
    end

    def to_html
      instance.to_html
    end

    def instance
      Message.new(locals)
    end
  end
end
