module Mint
  module IconGenerator
    extend self

    def convert(image, size : UInt16, save_path = nil)
      begin
        image_transformed = ImgKit::Image.new(image)
      rescue exception : ImgKit::ImgException
        raise ImageCorrupt, {
          "name" => image,
        }
      end

      begin
        image_transformed.resize(width: size, height: size)
      rescue exception : ImgKit::ResizeException
        raise ImageResizeFailed, {
          "name" => image,
        }
      end

      unless save_path.nil?
        image_transformed.save(save_path)
      end

      image_transformed.finish

      image_transformed
    end
  end
end
