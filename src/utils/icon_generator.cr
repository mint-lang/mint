module Mint
  module IconGenerator
    extend self

    def convert(image, size)
      output =
        IO::Memory.new

      error =
        IO::Memory.new

      status =
        Process.run(
          "convert #{image} -resize #{size}x#{size} -",
          shell: true, error: error, output: output)

      if status.success?
        output.to_s
      else
        ""
      end
    end
  end
end
