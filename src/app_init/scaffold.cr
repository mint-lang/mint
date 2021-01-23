module Mint
  class Scaffold
    APP_DIR = Path[__DIR__, "app"]

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
      FileUtils.cp_r(APP_DIR.to_s, "./")
    end

    private def touch_config
      file_path = "mint.json"
      FileUtils.mkdir_p File.dirname(file_path)
      File.write(file_path, json.to_pretty_json)
    end

    private def show_created_files(path : Path, indent : Int32 = 0)
      tabs = " " * indent
      dirs = %w[]
      files = %w[]

      Dir.each_child(path) do |child|
        child_path = File.join(path, child)
        case
        when File.directory?(child_path)
          dirs << child
        when File.file?(child_path)
          files << child
        end
      end

      dirs.each do |child|
        terminal.puts "#{tabs}#{ARROW} #{child}"
        show_created_files(Path[path, child], indent + 2)
      end

      files.each do |child|
        terminal.puts "#{tabs}#{ARROW} #{child}"
      end
    end

    def json
      {
        "name"        => name,
        "application" => {
          "head"  => "assets/head.html",
          "title" => name,
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
