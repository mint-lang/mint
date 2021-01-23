module Mint
  class Installer
    class FixedConstraint
      getter version, target, upper, lower

      @upper : Semver

      def initialize(@version : Semver, @target : String)
        @upper = version.next_patch
        @lower = version
      end

      def to_s(io : IO)
        io << target << " as " << version
      end

      def ==(other)
        to_s == other.to_s
      end
    end
  end
end
