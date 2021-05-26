module Mint
  module IconGenerator
    extend self

    def convert(image, size)
      canvas = PNGUtil.read(image)
      size = size.to_i32
      canvas.resize(size, size)
      output = IO::Memory.new
      PNGUtil.write(canvas, output)
      output.to_s
    end
  end
end
