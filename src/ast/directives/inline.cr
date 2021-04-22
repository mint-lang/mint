module Mint
  class Ast
    module Directives
      class Inline < Node
        getter real_path : Path
        getter path

        def initialize(@path : String,
                       @input : Data,
                       @from : Int32,
                       @to : Int32)
          @real_path = Path[Path[input.file].dirname, path].expand
        end

        def exists?
          File.exists?(real_path)
        end
      end
    end
  end
end
