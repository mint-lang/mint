class TypeChecker
  class Comparer
    def self.compare(entity, against)
      new(entity, against).compare
    end

    def self.compare(entity : Js, against : Type)
      against
    end

    def self.compare(entity : Type, against : Js)
      entity
    end

    def self.compare(entity : Record, against : Record)
      entity if entity.name == against.name && entity == against
    end

    def initialize(@a : Type, @b : Type)
    end

    def compare
      at = flatten(@a)
      bt = flatten(@b)
      result = resolve(at, bt)
      build(result) if result
    end

    def build(hash : Hash(String, String), prefix = "0") : Type
      type = Type.new(hash.delete(prefix) || "?")

      index = 0
      while hash.keys.any? { |key| key.starts_with?("#{prefix}.#{index}") }
        type.parameters << build(hash, "#{prefix}.#{index}")
        index += 1
      end

      type
    end

    def copy(from : {String, Hash(String, String)}, to : {String, Hash(String, String)})
      what = from[1].select do |key, value|
        key.starts_with?(from[0])
      end

      to[1].keys.each do |key|
        if key.starts_with?(to[0])
          what.each do |key2, value2|
            to[1][key + key2.lchop(from[0])] = value2
          end
        end
      end
    end

    def resolve(a, b) : Hash(String, String) | Nil
      result = a.map do |key, avalue|
        bvalue = b[key]?

        return nil unless bvalue

        ahole = avalue[0].in_set?("^A-Z")
        bhole = bvalue[0].in_set?("^A-Z")

        value =
          if ahole && bhole
            avalue
          elsif ahole
            a.each do |key2, value2|
              copy(from: {key, b}, to: {key2, a}) if value2 == avalue
            end
            a[key]
          elsif bhole
            b.each do |key2, value2|
              copy(from: {key, a}, to: {key2, b}) if value2 == bvalue
            end
            b[key]
          elsif avalue == bvalue
            bvalue
          else
            return nil
          end

        a.delete key
        b.delete key

        [key, value]
      end.to_h

      return nil if a.size != 0 || b.size != 0

      result
    end

    def flatten(a : Type, level = "0") : Hash(String, String)
      result = {} of String => String
      result[level] = a.name
      a.parameters.each_with_index do |parameter, index|
        result.merge! flatten(parameter, "#{level}.#{index}")
      end
      result
    end
  end
end
