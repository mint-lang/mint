module Mint
  class Ast
    class Data
      getter input, file

      def initialize(@input : String, @file : String)
      end

      def to_s(io : IO)
        io << '<' << file << ' ' << input[0, 10] << "...>"
      end
    end
  end
end
