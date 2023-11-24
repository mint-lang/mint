module Mint
  class Scaffold
    # The name of the project
    getter name : String

    # Whether or not to generate an empty project
    getter? bare : Bool

    # The path to the project
    getter path : Path

    def initialize(*, @name : String, @bare : Bool)
      @path = Path[name].expand

      if File.exists?(path)
        terminal.puts "#{WARNING} Directory exists, exiting..."
      else
        terminal.puts "#{COG} Writing files:"

        write_mint_json
        write_files

        show(path, indent: 2)
      end
    end

    # Writes the files of the project.
    private def write_files
      if bare?
        main =
          <<-MAIN
          component Main {
            fun render : Html {
              <></>
            }
          }
          MAIN

        File.write_p(Path[path, "source", "Main.mint"], main)
      else
        Assets.files.each do |file|
          next unless file.path.starts_with?("/scaffold/")
          File.write_p(Path[path, file.path.lchop("/scaffold/")], file)
        end
      end
    end

    # Writes the `mint.json` of the project.
    private def write_mint_json
      path =
        Path[self.path, "mint.json"]

      json =
        (bare? ? json_bare : self.json).to_pretty_json

      File.write_p(path, json)
    end

    # Displays the files in the given directory.
    private def show(directory : Path, *, indent : Int32 = 0)
      files = %w[]
      dirs = %w[]

      Dir.each_child(directory) do |child|
        path =
          Path[directory, child]

        case
        when File.directory?(path)
          dirs << child
        when File.file?(path)
          files << child
        end
      end

      prefix =
        "#{" " * indent}#{ARROW} "

      dirs.each do |child|
        terminal.puts "#{prefix}#{child}"

        show(Path[directory, child], indent: indent + 2)
      end

      files.each do |child|
        terminal.puts "#{prefix}#{child}"
      end
    end

    # The `mint.json` using the `--bare` flag.
    private def json_bare
      {
        "name"               => name,
        "source-directories" => [
          "source",
        ],
      }
    end

    # The `mint.json`.
    private def json
      {
        "name"        => name,
        "application" => {
          "icon"  => "assets/favicon.png",
          "head"  => "assets/head.html",
          "title" => name,
          "meta"  => {
            "viewport" => "width=device-width, initial-scale=1, user-scalable=no",
            "charset"  => "utf-8",
          },
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
