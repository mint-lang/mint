class Ast
  class Data
    getter input, file

    def initialize(@input : String, @file : String)
    end

    def to_s
      "<#{file} #{@input[0, 10]}...>"
    end

    def to_s(io)
      io << to_s
      io
    end
  end
end
