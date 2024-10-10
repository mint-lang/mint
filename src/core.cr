module Mint
  class Core
    extend BakedFileSystem

    bake_folder "../core/source"

    class_getter cache : Hash(String, Ast) = {} of String => Ast

    class_getter json : MintJson = MintJson.parse(
      contents: %({"name": "core"}),
      path: "core/mint.json")

    class_getter ast : Ast do
      files.reduce(Ast.new) do |memo, file|
        (@@cache[file.path] ||= Parser.parse(file.read, file.path)).try do |ast|
          memo.merge(ast)
        end
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
