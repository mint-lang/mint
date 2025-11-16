module Mint
  class TypeChecker
    class Tag
      getter name : String

      property parameters = [] of Checkable
      property label : String?

      def initialize(@name)
      end

      def to_mint
        to_s
      end

      def to_pretty
        to_s
      end

      def to_s(io : IO)
        io << "'"
        io << name
        io << "'"
      end

      def have_holes?
        false
      end
    end

    class Tags
      getter options : Array(Checkable)
      getter name : String = ""

      property parameters = [] of Checkable
      property label : String?

      getter inferred : Bool

      def initialize(options, *, @label = nil, @inferred = false)
        @options = options.uniq!
      end

      def to_mint
        to_s
      end

      def to_pretty
        to_s
      end

      def to_s(io : IO)
        options.join(io, " | ")
      end

      def have_holes?
        false
      end
    end

    class Type
      getter parameters : Array(Checkable)
      getter name : String

      property optional_count : Int32 = 0
      property label : String?

      def initialize(@name, @parameters = [] of Checkable, @label = nil)
      end

      def to_mint
        to_s
      end

      def to_pretty
        if parameters.empty?
          name
        else
          params =
            parameters.map do |param|
              pretty =
                param.to_pretty.as(String)

              if param.label
                "#{param.label}: #{pretty}"
              else
                pretty
              end
            end

          if params.size > 1 || params[0].includes?("\n")
            "#{name}(\n#{params.join(",\n").indent})"
          else
            "#{name}(#{params[0]})"
          end
        end
      end

      def have_holes?
        parameters.any?(&.have_holes?)
      end

      def to_s(io : IO)
        io << name
        unless parameters.empty?
          io << '('
          parameters.join(io, ", ")
          io << ')'
        end
      end
    end
  end
end
