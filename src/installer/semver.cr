module Mint
  class Installer
    class Semver
      def self.parse(string : String)
        parts = string.split('.')

        raise ArgumentError.new if parts.size > 3

        major = parts[0]?.to_s.to_i32
        minor = parts[1]?.to_s.to_i32
        patch = parts[2]?.to_s.to_i32

        new major, minor, patch
      rescue ArgumentError
      end

      getter major, minor, patch

      def initialize(@major = 0, @minor = 0, @patch = 0)
      end

      def to_s(io : IO)
        io << major << '.' << minor << '.' << patch
      end

      def next_patch
        self.class.new major, minor, patch + 1
      end

      def ==(other)
        major == other.major &&
          minor == other.minor &&
          patch == other.patch
      end

      def <(other) : Bool
        if major < other.major
          true
        elsif major > other.major
          false
        else # Major equals
          if minor < other.minor
            true
          elsif minor > other.minor
            false
          else # Minor equals
            if patch < other.patch
              true
            else # Patch is grater
              false
            end
          end
        end
      end

      def >(other) : Bool
        if major > other.major
          true
        elsif major < other.major
          false
        else # Major equals
          if minor > other.minor
            true
          elsif minor < other.minor
            false
          else # Minor equals
            if patch > other.patch
              true
            else # Patch is less
              false
            end
          end
        end
      end

      def >=(other) : Bool
        if major > other.major
          true
        elsif major < other.major
          false
        else # Major equals
          if minor > other.minor
            true
          elsif minor < other.minor
            false
          else # Minor equals
            if patch >= other.patch
              true
            else # Patch is less
              false
            end
          end
        end
      end
    end
  end
end
