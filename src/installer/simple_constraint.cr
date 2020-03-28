module Mint
  class Installer
    class SimpleConstraint
      getter upper, lower

      def initialize(@lower : Semver, @upper : Semver)
      end

      def to_s(io : IO)
        io << lower << " <= v < " << upper
      end

      def ==(other)
        to_s == other.to_s
      end
    end
  end
end
