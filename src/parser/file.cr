module Mint
  class Parser
    class File
      getter contents, path

      def initialize(@contents : String, @path : String)
      end

      def to_s(io : IO)
        io << '<' << file << ' ' << contents[0, 10] << "...>"
      end
    end
  end
end
