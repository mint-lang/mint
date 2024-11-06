class Dir
  def self.safe_delete(directory, &)
    return unless Dir.exists?(directory)
    yield
    FileUtils.rm_rf(directory)
  end

  def self.tempdir(&)
    path =
      Path[tempdir, Random::Secure.hex]

    begin
      FileUtils.mkdir_p(path)
      FileUtils.cd(path) { yield }
    ensure
      FileUtils.rm_rf(path)
    end
  end
end
