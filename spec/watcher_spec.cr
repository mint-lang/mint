require "./spec_helper"

describe Mint::Watcher do
  it do
    Path[Dir.tempdir, Random::Secure.hex].tap do |directory|
      FileUtils.mkdir_p(directory)

      file1 =
        Path["#{directory}", "file1.txt"]
          .tap(&->FileUtils.touch(Path))
          .to_s

      file2 =
        Path["#{directory}", "file2.txt"]
          .tap(&->FileUtils.touch(Path))
          .to_s

      modified =
        [] of String

      watcher =
        Mint::Watcher
          .new { |items| modified = items }
          .tap(&.patterns = ["#{directory}/**/*"])

      # Returns all files
      modified.should eq([file1, file2])

      # Returns only modified files
      FileUtils.touch(file2)
      watcher.scan(:modified)
      modified.should eq([file2])

      # Returns deleted files
      FileUtils.rm(file2)
      watcher.scan(:modified)
      modified.should eq([file2])

      # Returns all files
      watcher.patterns = ["#{directory}/**/*"]
      watcher.scan(:modified)
      modified.should eq([file1])
    ensure
      FileUtils.rm_rf(directory)
    end
  end
end
