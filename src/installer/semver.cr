module Mint
  class Installer
    class Semver
      def self.parse?(string : String)
        parts = string.split('.')

        return unless parts.size == 3
        return unless parts.all?(&.chars.all?(&.number?))

        major = parts[0].to_i
        minor = parts[1].to_i
        patch = parts[2].to_i

        new major, minor, patch
      end

      def self.parse(string : String)
        parse?(string) || raise ArgumentError.new
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

      def_equals @major, @minor, @patch

      def <(other) : Bool
        case
        when major < other.major
          true
        when major > other.major
          false
        else # Major equals
          case
          when minor < other.minor
            true
          when minor > other.minor
            false
          else # Minor equals
            patch < other.patch
          end
        end
      end

      def >(other) : Bool
        case
        when major > other.major
          true
        when major < other.major
          false
        else # Major equals
          case
          when minor > other.minor
            true
          when minor < other.minor
            false
          else # Minor equals
            patch > other.patch
          end
        end
      end

      def >=(other) : Bool
        case
        when major > other.major
          true
        when major < other.major
          false
        else # Major equals
          case
          when minor > other.minor
            true
          when minor < other.minor
            false
          else # Minor equals
            patch >= other.patch
          end
        end
      end
    end
  end
end
