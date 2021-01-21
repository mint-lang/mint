module Mint
  class Scaffold
    APP = "#{__DIR__}/app"

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
      FileUtils.cd path.to_s

      terminal.puts "#{COG} Writing initial files:"

      touch_initial_files
      touch_config

      show_created_files(path.to_s, "  ")
    end

    private def touch_initial_files
      FileUtils.cp_r(APP, "./")
    end

    private def touch_config
        file_path = "mint.json"
        FileUtils.mkdir_p File.dirname(file_path)
        File.write(file_path, json.to_pretty_json)
    end

    private def show_created_files(path : String, tabs : String)
      # Show directories first
      current_dir = Dir.open path

      dirs = current_dir.select do |child| 
        child != "." &&
        child != ".." &&
        File.directory? File.join(path, child)
      end

      files = current_dir.select { |child| File.file? File.join(path, child) }

      dirs.each do |child|
        child_path = File.join(path, child)
        terminal.puts "#{tabs}#{ARROW} #{child}" 
        show_created_files(child_path, "  #{tabs}")
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
            "assets/style.css" 
          ]
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
