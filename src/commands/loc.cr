module Mint
  class Cli < Admiral::Command
    class Loc < Admiral::Command
      include Command

      define_help description: "Counts Lines of Code"

      def run
        execute "Counting Lines of Code" do
          file_count =
            files.size.to_s.colorize.mode(:bold)

          line_count =
            count.to_s.colorize.mode(:bold)

          terminal.print "#{COG} Files: #{file_count}\n"
          terminal.print "#{COG} Lines of code: #{line_count}\n"
        end
      end

      def files
        Dir.glob(SourceFiles.all).to_a
      end

      def count
        files.reduce(0) do |memo, file|
          count =
            File
              .read(file)
              .split("\n")
              .count { |line| !line.empty? }

          count + memo
        end
      end
    end
  end
end
