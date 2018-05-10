module Mint
  class Assets
    BakedFileSystem.load("./assets")

    def self.read(message)
      get(message).read
    end
  end
end
