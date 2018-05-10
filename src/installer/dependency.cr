module Mint
  class Installer
    class Dependency
      getter repository, constraint, name

      def initialize(@name : String, @repository : String, @constraint : Constraint)
      end
    end
  end
end
