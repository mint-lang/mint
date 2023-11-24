class File
  def self.write_p(path, contents)
    FileUtils.mkdir_p File.dirname(path)
    File.write path, contents
  end
end
