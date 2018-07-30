module Mint
  class Decoder
    @decoders = {} of TypeChecker::Record => String

    def compile(node : TypeChecker::Record)
      return @decoders[node] if @decoders[node]?

      consts =
        node.fields.map do |key, value|
          decoder =
            generate value

          from =
            node.mappings[key]? || key

          <<-JS
          let #{key} = Decoder.field(`#{from}`, #{decoder})(input)
          if (#{key} instanceof Err) { return #{key} }
          JS
        end

      fields =
        node
          .fields
          .keys
          .map { |key| "#{key}: #{key}.value" }

      body =
        <<-JS
        #{consts.join("\n\n")}

        return new Ok(new $$#{node.name.gsub('.', '_')}({
        #{fields.join(",\n").indent}
        }))
        JS

      @decoders[node] =
        <<-JS
        (input) => {
        #{body.indent}
        }
        JS
    end

    def generate(node : TypeChecker::Variable)
      # This should never happen because of the typechecker!
      raise "Cannot generate a decoder for a type variable!"
    end

    def generate(node : TypeChecker::Record)
      compile node

      "$$#{node.name}.decode"
    end

    def generate(node : TypeChecker::Type)
      case node.name
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
      else
        # This should never happen because of the typechecker!
        raise "Cannot generate a decoder for #{node.to_s}!"
      end
    end
  end
end
