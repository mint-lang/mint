module Mint
  class Core
    BakedFileSystem.load("../core/source")

    class_getter ast

    @@ast : Ast = files.reduce(Ast.new) do |memo, file|
      memo.merge(Parser.parse(file.read, file.path))
    end

    def self.read(message)
      get(message).read
    end
  end
end
