module Mint
  class TypeChecker
    class Type
      getter name, parameters

      def initialize(@name : String, @parameters = [] of Type)
      end

      def to_s
        if parameters.empty?
          name
        else
          "#{name}(#{parameters.join(", ")})"
        end
      end

      def to_s(io)
        io << to_s
        io
      end

      def to_pretty
        if parameters.empty?
          name
        else
          params =
            parameters.map(&.to_pretty.as(String))

          if params.any?(&.=~(/\n/)) || params.size > 4
            "#{name}(\n#{params.join(",\n").indent})"
          else
            "#{name}(#{params.join(", ")})"
          end
        end
      end
    end

    class Js < Type
    end

    class Record < Type
      getter fields

      def initialize(@name : String, @fields = {} of String => Type)
        @parameters = [] of Type
      end

      def to_pretty
        return name if fields.empty?

        defs =
          fields
            .map do |key, value|
            result = value.to_pretty
            if result =~ /\n/
              "#{key}:\n#{value.to_pretty.indent}"
            else
              "#{key}: #{value.to_pretty}"
            end
          end

        if defs.any?(&.=~(/\n/)) || defs.size > 4
          "#{name}(\n#{defs.join(",\n").indent})"
        else
          "#{name}(#{defs.join(", ")})"
        end
      end

      def to_s
        if fields.empty?
          name
        else
          defs = fields.map { |key, value| "#{key}: #{value}" }.join(", ")
          "#{name}(#{defs})"
        end
      end

      def ==(other : Record)
        self == other.fields
      end

      def ==(other : Hash(String, Type))
        return false if fields.size != other.size

        other.all? do |key, type|
          next false unless fields[key]?
          !Comparer.compare(fields[key], type).nil?
        end
      end
    end
  end
end
