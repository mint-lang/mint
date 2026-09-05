module Mint
  class Parser
    class File
      getter contents, path

      # The relative path of the file to the project root (closest `mint.json`).
      getter relative_path : String do
        ::File.relative_path_from_ancestor(path, "mint.json")
      end

      getter relative_path_posix : String do
        Path[relative_path].to_posix.to_s
      end

      def initialize(@contents : String, @path : String)
      end

      def to_s(io : IO)
        io << '<' << file << ' ' << contents[0, 10] << "...>"
      end
    end
  end
end
