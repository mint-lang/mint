module Mint
  class Scaffold
    extend BakedFileSystem

    bake_folder "./app"

    getter path : Path

    def self.run(name : Path | String)
      new(Path[name]).run
    end

    def initialize(path : Path)
      @path = path.expand
    end

    def name
      path.basename
    end

    def run
      directory =
        name
          .colorize(:light_green)
          .mode(:bold)

      terminal.puts "#{COG} Creating directory: #{directory}"

      FileUtils.mkdir_p path.to_s

      Dir.cd(path) do
        terminal.puts "#{COG} Writing initial files:"

        touch_initial_files
        touch_config

        show_created_files(path, indent: 2)
      end
    end

    private def touch_initial_files
      @@files.each do |file|
        # The baked files start with a slash "/"
        file_path =
          file.path.lchop

        FileUtils.mkdir_p File.dirname(file_path)
        File.write(file_path, file)
      end
    end

    private def touch_config
      File.write("mint.json", json.to_pretty_json)
    end

    private def show_created_files(path : Path, indent : Int32 = 0)
      dirs = %w[]
      files = %w[]

      Dir.each_child(path) do |child|
        child_path = Path[path, child]
        case
        when File.directory?(child_path)
          dirs << child
        when File.file?(child_path)
          files << child
        end
      end

      prefix = "#{" " * indent}#{ARROW} "

      dirs.each do |child|
        terminal << prefix << child << '\n'
        show_created_files(Path[path, child], indent + 2)
      end

      files.each do |child|
        terminal << prefix << child << '\n'
      end
    end

    def json
      {
        "name"        => name,
        "application" => {
          "head"  => "assets/head.html",
          "title" => name,
          "icon"  => "assets/favicon.png",
        },
        "external" => {
          "stylesheets" => [
            "assets/style.css",
          ],
        },
        "source-directories" => [
          "source",
        ],
        "test-directories" => [
          "tests",
        ],
      }
    end

    private def terminal
      Render::Terminal::STDOUT
    end
  end
end
