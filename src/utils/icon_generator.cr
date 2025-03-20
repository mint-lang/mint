module Mint
  module IconGenerator
    extend self

    @@executable : String?
    @@searched = false

    # ImageMagick 7 provides the `magick` command while ImageMagick 6 only
    # provides `convert`, so `magick` is preferred.
    #
    # On Windows `convert.exe` is also the name of a built in utility (it
    # converts FAT volumes to NTFS) which lives in the system directory and
    # would be found on every machine, so it is ignored.
    def executable : String?
      unless @@searched
        @@searched = true

        @@executable =
          case
          when path = Process.find_executable("magick")
            path
          when path = Process.find_executable("convert")
            path unless system_utility?(path)
          end
      end

      @@executable
    end

    def convert(image, size)
      return "" unless command = executable

      output =
        IO::Memory.new

      error =
        IO::Memory.new

      status =
        Process.run(
          command,
          args: [image, "-resize", "#{size}x#{size}", "png:-"],
          error: error, output: output)

      if status.success?
        output.to_s
      else
        ""
      end
    end

    private def system_utility?(path : String) : Bool
      {% if flag?(:windows) %}
        root =
          Path[ENV["SystemRoot"]? || "C:\\Windows"].normalize.to_s

        Path[path].normalize.to_s.starts_with?("#{root}/")
      {% else %}
        false
      {% end %}
    end
  end
end
