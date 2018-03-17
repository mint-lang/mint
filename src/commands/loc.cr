class Cli < Admiral::Command
  class Loc < Admiral::Command
    include Command

    define_help description: "Counts lines of code"

    getter files

    @files : Array(String)

    def initialize(*args, **params)
      super(*args, **params)
      @files = Dir.glob(SourceFiles.all).to_a
    end

    def run
      execute "Counting Lines of Code" do
        puts "Files: #{files.size}"
        puts "Lines of code: #{count}"
      end
    end

    def count
      files.reduce(0) do |memo, file|
        count =
          File
            .read(file)
            .split("\n")
            .reject(&.empty?)
            .size

        count + memo
      end
    end
  end
end
