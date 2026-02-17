module Mint
  class Warning
    include Message

    def initialize(@name : Symbol)
    end

    def to_terminal
      to_terminal("WARNING")
    end

    def to_s
      to_terminal.to_s
    end
  end
end
