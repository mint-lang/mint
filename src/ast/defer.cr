require "digest/sha1"

module Mint
  class Ast
    class Defer < Node
      getter body, id

      def initialize(@file : Parser::File,
                     @from : Int64,
                     @body : Node,
                     @to : Int64)
        @id = Digest::SHA1.hexdigest(source)
      end
    end
  end
end
