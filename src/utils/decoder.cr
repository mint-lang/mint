module Mint
  class Decoder
    @mappings = {} of TypeChecker::Record => String

    getter js : Js

    def initialize(@js)
    end

    def compile(node : TypeChecker::Record)
      @mappings[node] ||= begin
        mappings =
          node.fields.each_with_object({} of String => String) do |(key, value), memo|
            decoder =
              generate value

            from =
              node.mappings[key]? || key

            memo[key] = js.array([%("#{from}"), decoder])
          end

        @mappings[node] = js.object(mappings)
      end
    end

    def underscorize(value)
      value.gsub('.', '_')
    end

    def generate(node : TypeChecker::Variable)
      # This should never happen because of the typechecker!
      raise "Cannot generate a decoder for a type variable!"
    end

    def generate(node : TypeChecker::Record)
      compile node

      "((_)=>#{js.class_of(node.name)}.decode(_))"
    end

    def generate(node : TypeChecker::Type)
      case node.name
      when "Object"
        "Decoder.object"
      when "String"
        "Decoder.string"
      when "Bool"
        "Decoder.boolean"
      when "Number"
        "Decoder.number"
      when "Time"
        "Decoder.time"
      when "Maybe"
        decoder =
          generate node.parameters.first

        "Decoder.maybe(#{decoder})"
      when "Array"
        decoder =
          generate node.parameters.first

        "Decoder.array(#{decoder})"
      when "Map"
        decoder =
          generate node.parameters.last

        "Decoder.map(#{decoder})"
      else
        # This should never happen because of the typechecker!
        raise "Cannot generate a decoder for #{node.to_s}!"
      end
    end
  end
end
