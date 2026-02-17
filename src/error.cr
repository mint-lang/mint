module Mint
  # Represents a raisable rich and descriptive error.
  class Error < Exception
    include Message

    def initialize(@name : Symbol)
    end

    def to_terminal
      to_terminal("ERROR")
    end

    def to_s
      to_terminal.to_s
    end
  end
end
