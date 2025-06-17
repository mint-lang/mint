module Mint
  class Compiler
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
        if type.parameters.first.name == "String"
          js.call(Builtin::EncodeMap, [encoder(type.parameters.last)])
        else
          js.call(Builtin::EncodeMapArray, [
            encoder(type.parameters.first),
            encoder(type.parameters.last),
          ])
        end
      when "Time"
        [Builtin::EncodeTime] of Item
      when "Tuple"
        encoders =
          type.parameters.map { |item| encoder(item) }

        js.call(Builtin::EncodeTuple, [js.array(encoders)])
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

            encoders =
              variants.compact_map do |item|
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
                          unreachable! "Cannot generate an encoder for #{Debugger.dbg(param)}!"
                        end

                      encoder(variant_type)
                    end)
                  else
                    [] of Item
                  end

                js.array([[item] of Item, parameters])
              end

            js.call(Builtin::EncodeVariant, [js.array(encoders)])
          end
        end || [Builtin::Identity] of Item
      end
    end

    def encoder(node : TypeChecker::Variable)
      unreachable! "Cannot generate an encoder for a type variable!"
    end
  end
end
