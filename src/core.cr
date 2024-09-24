module Mint
  class Core
    extend BakedFileSystem

    bake_folder "../core/source"

    class_getter json : MintJson = MintJson.parse(
      contents: %({"name": "core"}),
      path: "core/mint.json")

    class_getter ast : Ast do
      files.reduce(Ast.new) do |memo, file|
        memo.merge Parser.parse(file.read, file.path)
      end
    end

    def self.read?(path)
      get?(path).try(&.gets_to_end)
    end

    def self.read(path)
      get(path).gets_to_end
    end
  end
end
