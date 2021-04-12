module Mint
  class Ast
    module Directives
      class Asset < Node
        getter real_path : Path
        getter path

        def initialize(@path : String,
                       @input : Data,
                       @from : Int32,
                       @to : Int32)
          @real_path = Path[Path[input.file].dirname, path].expand
        end

        def filename
          return unless exists?

          hash =
            Digest::MD5.new
              .update(File.read(real_path))
              .final
              .hexstring

          extname =
            real_path.extension

          basename =
            real_path.basename(extname)

          "#{basename}_#{hash}#{extname}"
        end

        def exists?
          File.exists?(real_path)
        end
      end
    end
  end
end
