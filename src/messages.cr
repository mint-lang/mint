require "baked_file_system"

class Messages
  BakedFileSystem.load("./messages")

  def self.read(message)
    get(message).read
  rescue BakedFileSystem::NoSuchFileError
    message
  end
end
