require "digest/md5"

module Mint
  module Skippable
    @skip = [] of {String, String}

    def replace_skipped(result)
      @skip.reverse.reduce(result) do |memo, (digest, item)|
        memo.sub(digest, item)
      end
    end

    def skip
      result =
        yield

      digest =
        Digest::MD5.hexdigest(result)

      @skip << {digest, result}

      digest
    end
  end
end
