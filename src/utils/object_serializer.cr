module Mint
  # This class handles the generation of a serializer of Mint types into
  # JavaScript Objects.
  class ObjectSerializer
    @mappings = {} of TypeChecker::Record => String

    getter js : Js

    def initialize(@js)
    end

    # Generates mappings for a Record:
    #
    # // The encoder is optional
    # { field: ["generated key", decoder, encoder] }
    def generate_mappings(node : TypeChecker::Record)
      @mappings[node] ||= begin
        mappings =
          node.fields.each_with_object({} of String => String) do |(key, value), memo|
            decoder =
              self.decoder value

            encoder =
              self.encoder value

            mapping =
              node.mappings[key]? || key

            memo[key] = js.array([%("#{mapping}"), decoder, encoder].compact)
          end

        @mappings[node] = js.object(mappings)
      end
    end

    def encoder(node : TypeChecker::Record)
      "((_)=>#{js.class_of(node.name)}.encode(_))"
    end

    def encoder(node : TypeChecker::Variable)
      # This should never happen because of the typechecker!
      raise "Cannot generate an encoder for a type variable!"
    end

    def encoder(node : TypeChecker::Type)
      case node.name
      when "Time"
        "Encoder.time"
      when "Array"
        "Encoder.array(#{encoder(node.parameters.first)})"
      when "Maybe"
        "Encoder.maybe(#{encoder(node.parameters.first)})"
      when "Map"
        "Encoder.map(#{encoder(node.parameters.last)})"
      end
    end

    def decoder(node : TypeChecker::Variable)
      # This should never happen because of the typechecker!
      raise "Cannot generate a decoder for a type variable!"
    end

    def decoder(node : TypeChecker::Record)
      generate_mappings node

      "((_)=>#{js.class_of(node.name)}.decode(_))"
    end

    def decoder(node : TypeChecker::Type)
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
        "Decoder.maybe(#{decoder(node.parameters.first)})"
      when "Array"
        "Decoder.array(#{decoder(node.parameters.first)})"
      when "Map"
        "Decoder.map(#{decoder(node.parameters.last)})"
      else
        # This should never happen because of the typechecker!
        raise "Cannot generate a decoder for #{node}!"
      end
    end
  end
end
