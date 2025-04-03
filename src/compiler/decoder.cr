module Mint
  class Compiler
    def decoder(type : TypeChecker::Record) : Compiled
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
            add node, id, js.call(Builtin::Decoder, [js.string(type.name), js.object(item), ok, err])
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
        if node = ast.type_definitions.find(&.name.value.==(type.name))
          case variants = node.fields
          when Array(Ast::TypeVariant)
            substitutions =
              node
                .parameters
                .each_with_index
                .each_with_object({} of String => TypeChecker::Checkable) do |(item, index), memo|
                  memo[item.value] = type.parameters[index]
                end

            items =
              variants.each_with_object({} of String => Compiled) do |item, memo|
                parameters =
                  if item.parameters.size > 0
                    js.array(item.parameters.map do |param|
                      variant_type =
                        case param
                        when Ast::Type
                          substitute(cache[param], substitutions)
                        when Ast::TypeDefinitionField
                          substitute(cache[param.type], substitutions)
                        when Ast::TypeVariable
                          substitutions[param.value]
                        else
                          unreachable! "Cannot generate a decoder for #{Debugger.dbg(item)}!"
                        end

                      decoder(variant_type)
                    end)
                  else
                    js.null
                  end

                memo[%("#{node.name.value}.#{item.value.value}")] =
                  js.call(Builtin::DecodeVariant, [
                    [item] of Item,
                    parameters,
                    ok,
                    err,
                  ])
              end

            [
              Decoder.new.tap do |id|
                add node, id, js.call(Builtin::DecodeType, [
                  js.string(type.name),
                  js.object(items),
                  ok, err,
                ])
              end,
            ] of Item
          end
        end || unreachable! "Cannot generate a decoder for #{type}!"
      end
    end

    def decoder(node : TypeChecker::Variable)
      unreachable! "Cannot generate a decoder for a type variable!"
    end

    def substitute(
      type : TypeChecker::Checkable,
      substitutions : Hash(String, TypeChecker::Checkable),
    ) : TypeChecker::Checkable
      case type
      in TypeChecker::Type
        TypeChecker::Type.new(type.name, type.parameters.map do |item|
          substitute(item, substitutions)
        end)
      in TypeChecker::Record
        type
      in TypeChecker::Variable
        if found = substitutions[type.name]?
          found
        else
          unreachable! "Cannot find substition for variable: #{type.name}"
        end
      end
    end
  end
end
