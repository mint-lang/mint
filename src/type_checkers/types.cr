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
  end

  class Js < Type
  end

  class Record < Type
    getter fields

    def initialize(@name : String, @fields = {} of String => Type)
      @parameters = [] of Type
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
