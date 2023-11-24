module Mint
  class Ast
    module Directives
      class FileBased < Node
        # The real path of the asset on the disk.
        getter real_path : Path

        # The given path of the asset.
        getter path : String

        def initialize(
          @file : Parser::File,
          @path : String,
          @from : Int64,
          @to : Int64
        )
          @real_path = Path[file.path].sibling(path).expand
        end

        # Returns the hashed filename of the target. For the build version it
        # uses the the file contents as the hash value to make sure that the
        # file will not be cached.
        def filename(*, build : Bool) : String?
          raise "Should not happen!" unless exists?

          hash_base =
            build ? file_contents : real_path.to_s

          hash =
            Digest::MD5.new
              .update(hash_base)
              .final
              .hexstring

          "#{real_path.stem}_#{hash}#{real_path.extension}"
        end

        # Returns whether the file exists.
        def exists?
          File.exists?(real_path)
        end

        # Returns the files contents.
        def file_contents : String
          File.read(real_path)
        end
      end

      class HighlightFile < FileBased
      end

      class Inline < FileBased
      end

      class Asset < FileBased
      end

      class Svg < FileBased
      end
    end
  end
end
