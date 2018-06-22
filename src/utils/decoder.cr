module Mint
  class Decoder
    @decoders = {} of TypeChecker::Record => String

    def id(name)
      "$$#{name.gsub('.', '_')}"
    end

    def compile
      @decoders
        .map { |node, value| "const #{id(node.name)} = #{value}" }
        .join("\n\n")
    end

    def generate(node : TypeChecker::Record)
      return id(node.name) if @decoders[node]?

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

        return new Ok({
        #{fields.join(",\n").indent}
        })
        JS

      @decoders[node] =
        <<-JS
        (input) => {
        #{body.indent}
        }
        JS

      id(node.name)
    end

    def generate(node : TypeChecker::Variable)
      # This should never happen because of the typechecker!
      raise "Cannot generate a decoder for a type variable!"
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
