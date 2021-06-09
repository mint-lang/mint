require "./record"

module Mint
  class TypeChecker
    class PartialRecord < Record
      def to_s(io : IO)
        if fields.empty?
          io << "(...)"
        else
          io << '('
          fields.join(io, ", ") do |(key, value), inner_io|
            inner_io << key << ": " << value
          end
          io << ", ...)"
        end
      end

      def to_pretty
        return "(...)" if fields.empty?

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

        defs << "..."

        if defs.any?(&.includes?('\n')) || defs.size > 4
          "(\n#{defs.join(",\n").indent})"
        else
          "(#{defs.join(", ")})"
        end
      end

      def ==(other : Hash(String, Checkable))
        fields.all? do |key, type|
          next false unless other[key]?
          !Comparer.compare(other[key], type).nil?
        end
      end
    end
  end
end
