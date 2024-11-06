module Mint
  class Cli < Admiral::Command
    class Loc < Admiral::Command
      include Command

      define_help description: "Counts LOC (lines of code)."

      def run
        execute "Counting lines of code" do
          files =
            Dir.glob(SourceFiles.globs(MintJson.current)).to_a

          file_count =
            files.size.to_s.colorize.mode(:bold)

          line_count =
            files.reduce(0) do |memo, file|
              count =
                File.read(file).lines.count(&.presence)

              count + memo
            end.to_s.colorize.mode(:bold)

          terminal.puts "#{COG} Files: #{file_count}"
          terminal.puts "#{COG} Lines of code: #{line_count}"
        end
      end
    end
  end
end
