class File
  def self.write_p(path, contents)
    FileUtils.mkdir_p File.dirname(path)
    File.write path, contents
  end

  def self.find_in_ancestors(base : String, name : String) : String?
    root = File.dirname(base)

    loop do
      return nil if root == "." || root == "/"

      if File.exists?(path = Path[root, name])
        return path.to_s
      else
        root = File.dirname(root)
      end
    end
  end
end
