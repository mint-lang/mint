class Dir
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
