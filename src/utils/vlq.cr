module Mint
  # Support for encoding the variable length quantity format.
  #
  # This implementation is heavily based on https://github.com/mozilla/source-map
  # Copyright 2009-2011, Mozilla Foundation and contributors, BSD
  #
  module VLQ
    # A single base 64 digit can contain 6 bits of data. For the base 64
    # variable length quantities we use in the source map spec, the first bit
    # is the sign, the next four bits are the actual value, and the 6th bit is
    # the continuation bit. The continuation bit tells us whether there are
    # more digits in this value following this digit.
    #
    #   Continuation
    #   |    Sign
    #   |    |
    #   V    V
    #   101011
    VLQ_BASE_SHIFT = 5

    # binary: 100000
    VLQ_BASE = 1 << VLQ_BASE_SHIFT

    # binary: 011111
    VLQ_BASE_MASK = VLQ_BASE - 1

    # binary: 100000
    VLQ_CONTINUATION_BIT = VLQ_BASE

    BASE64_DIGITS =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".chars

    # Returns the base 64 VLQ encoded value.
    def self.encode(int)
      vlq = to_vlq_signed(int)
      encoded = ""
      cond = true

      while cond
        digit = vlq & VLQ_BASE_MASK
        vlq >>= VLQ_BASE_SHIFT
        digit |= VLQ_CONTINUATION_BIT if vlq > 0
        encoded += base64_encode(digit)
        cond = vlq > 0
      end

      encoded
    end

    private def self.base64_encode(int)
      BASE64_DIGITS[int]? || raise ArgumentError.new "#{int} is not a valid base64 digit"
    end

    # Converts from a two's-complement integer to an integer where the
    # sign bit is placed in the least significant bit. For example, as decimals:
    #  1 becomes 2 (10 binary), -1 becomes 3 (11 binary)
    #  2 becomes 4 (100 binary), -2 becomes 5 (101 binary)
    private def self.to_vlq_signed(int)
      if int < 0
        ((-int) << 1) + 1
      else
        int << 1
      end
    end
  end
end
