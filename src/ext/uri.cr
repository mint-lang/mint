class URI
  # Returns proper file path on Windows and Unix
  def file_path : String
    if scheme == "file"
      path = URI.decode(self.path.lchop("/"))

      if match = /([A-Z]):\/(.*)/i.match(path)
        "#{match[1].upcase}:\\#{match[2].gsub('/', '\\')}"
      else
        self.path
      end
    else
      raise "Not a file path!"
    end
  end
end
