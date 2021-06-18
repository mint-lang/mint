module Mint
  class TypeChecker
    class Record
      property parameters = [] of Checkable
      getter name, fields, mappings

      def initialize(
        @name : String,
        @fields = {} of String => Checkable,
        @mappings = {} of String => String?
      )
      end

      def to_pretty
        return name if fields.empty?

        defs =
          fields
            .map do |key, value|
              result = value.to_pretty
              if result.includes?('\n')
                "#{key}:\n#{value.to_pretty.indent}"
              else
                "#{key}: #{value.to_pretty}"
              end
            end

        if defs.any?(&.includes?('\n')) || defs.size > 4
          "#{name}(\n#{defs.join(",\n").indent})"
        else
          "#{name}(#{defs.join(", ")})"
        end
      end

      def to_mint
        name
      end

      def to_s(io : IO)
        io << name
        unless fields.empty?
          io << '('
          fields.join(io, ", ") do |(key, value), inner_io|
            inner_io << key << ": " << value
          end
          io << ')'
        end
      end

      def have_holes?
        fields.values.any?(&.have_holes?)
      end

      def ==(other : Record)
        self == other.fields
      end

      def ==(other : Hash(String, Checkable))
        return false unless fields.size == other.size

        other.all? do |key, type|
          next false unless fields[key]?
          !Comparer.compare(fields[key], type).nil?
        end
      end
    end
  end
end
