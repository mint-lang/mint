module Mint
  class Compiler2
    def decoder(type : TypeChecker::Record)
      @decoders[type] ||= begin
        node =
          ast.type_definitions.find!(&.name.value.==(type.name))

        item =
          type
            .fields
            .each_with_object({} of String => Compiled) do |(key, value), memo|
              decoder =
                self.decoder value

              if mapping = type.mappings[key]?
                decoder = js.array([decoder, [%("#{mapping}")] of Item])
              end

              memo[key] = decoder
            end

        [
          Decoder.new.tap do |id|
            add node, id, js.call(Builtin::Decoder, [js.object(item), ok, err])
          end,
        ] of Item
      end
    end

    def decoder(type : TypeChecker::Type) : Compiled
      case type.name
      when "Array"
        js.call(Builtin::DecodeArray, [decoder(type.parameters.first), ok, err])
      when "Map"
        js.call(Builtin::DecodeMap, [decoder(type.parameters.last), ok, err])
      when "Bool"
        js.call(Builtin::DecodeBoolean, [ok, err])
      when "Number"
        js.call(Builtin::DecodeNumber, [ok, err])
      when "String"
        js.call(Builtin::DecodeString, [ok, err])
      when "Time"
        js.call(Builtin::DecodeTime, [ok, err])
      when "Object"
        js.call(Builtin::DecodeObject, [ok])
      when "Maybe"
        js.call(
          Builtin::DecodeMaybe,
          [decoder(type.parameters.first), ok, err, just, nothing])
      when "Tuple"
        decoders =
          type.parameters.map { |item| decoder(item) }

        js.call(Builtin::DecodeTuple, [js.array(decoders), ok, err])
      else
        raise "Cannot generate a decoder for #{type}!"
      end
    end

    def decoder(node : TypeChecker::Variable)
      raise "Cannot generate a decoder for a type variable!"
    end
  end
end
