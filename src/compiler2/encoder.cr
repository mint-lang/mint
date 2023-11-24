module Mint
  class Compiler2
    def encoder(type : TypeChecker::Record) : Compiled
      @encoders[type] ||= begin
        node =
          ast.type_definitions.find!(&.name.value.==(type.name))

        item =
          type
            .fields
            .each_with_object({} of String => Compiled) do |(key, value), memo|
              encoder =
                self.encoder value

              if mapping = type.mappings[key]?
                encoder = js.array([encoder, [%("#{mapping}")] of Item])
              end

              memo[key] = encoder
            end

        [
          Encoder.new.tap do |id|
            add node, id, js.call(Builtin::Encoder, [js.object(item)])
          end,
        ] of Item
      end
    end

    def encoder(type : TypeChecker::Type) : Compiled
      case type.name
      when "Maybe"
        js.call(Builtin::EncodeMaybe, [encoder(type.parameters.first), just])
      when "Array"
        js.call(Builtin::EncodeArray, [encoder(type.parameters.first)])
      when "Map"
        js.call(Builtin::EncodeMap, [encoder(type.parameters.last)])
      when "Time"
        [Builtin::EncodeTime] of Item
      when "Tuple"
        encoders =
          type.parameters.map { |item| encoder(item) }

        js.call(Builtin::EncodeTuple, [js.array(encoders)])
      else
        [Builtin::Identity] of Item
      end
    end

    def encoder(node : TypeChecker::Variable)
      raise "Cannot generate an encoder for a type variable!"
    end
  end
end
