module Mint
  class Ast
    module Directives
      class Svg < Node
        getter real_path : Path
        getter path

        def initialize(@path : String,
                       @input : Data,
                       @from : Int32,
                       @to : Int32)
          @real_path = Path[input.file].sibling(path).expand
        end

        def exists?
          File.exists?(real_path)
        end

        def file_contents : String
          File.read(real_path)
        end
      end
    end
  end
end
