module Mint
  # Support for encoding/decoding the variable length quantity format.
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

    BASE64_VALUES =
      (0..64).reduce({} of Char => Int32) { |hash, i| hash[BASE64_DIGITS[i]] = i }

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

    # Decodes the next base 64 VLQ value from the given string and returns the
    # value and the rest of the string.
    def self.decode(str)
      chars = str.chars
      continue = true
      shift = 0
      vlq = 0

      while continue
        char = chars.shift or raise "Expected more digits in base 64 VLQ value."
        digit = base64_decode(char)
        continue = false if (digit & VLQ_CONTINUATION_BIT) == 0
        digit &= VLQ_BASE_MASK
        vlq += digit << shift
        shift += VLQ_BASE_SHIFT
      end

      [from_vlq_signed(vlq), String.new(chars)]
    end

    # Decode an array of variable length quantities from the given string
    def self.decode_array(str)
      output = [] of Tuple(Int32, String)
      while !str.empty?
        int, str = decode(str)
        output << int
      end
      output
    end

    private def self.base64_encode(int)
      BASE64_DIGITS[int]? || raise ArgumentError.new "#{int} is not a valid base64 digit"
    end

    private def self.base64_decode(char)
      BASE64_VALUES[char]? || raise ArgumentError.new "#{char} is not a valid base64 digit"
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

    # Converts to a two's-complement value from a value where the sign bit is
    # placed in the least significant bit. For example, as decimals:
    #
    #  2 (10 binary) becomes 1, 3 (11 binary) becomes -1
    #  4 (100 binary) becomes 2, 5 (101 binary) becomes -2
    private def self.from_vlq_signed(vlq)
      if vlq & 1 == 1
        -(vlq >> 1)
      else
        vlq >> 1
      end
    end
  end
end
