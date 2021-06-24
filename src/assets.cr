module Mint
  class Assets
    extend BakedFileSystem

    bake_folder "./assets"

    def self.read(path)
      get(path).gets_to_end
    end
  end
end
