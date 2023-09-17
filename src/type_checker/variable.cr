module Mint
  class TypeChecker
    class Variable
      @@id = 0

      property parameters = [] of Checkable
      property instance : Checkable?
      property label : String?

      getter name : String
      getter id : Int32

      def initialize(@name, @label = nil)
        @id = (@@id += 1)
      end

      def to_mint
        to_s
      end

      def to_s(io : IO)
        if obj = @instance
          obj.to_s(io)
        else
          io << name
        end
      end

      def to_pretty
        @instance.try(&.to_pretty) || name
      end

      def have_holes?
        true
      end
    end
  end
end
