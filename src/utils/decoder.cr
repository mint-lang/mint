module Mint
  class Decoder
    @decoders = {} of TypeChecker::Record => String

    getter js : Js

    def initialize(@js)
    end

    def compile(node : TypeChecker::Record)
      return @decoders[node] if @decoders[node]?

      consts =
        node.fields.map do |key, value|
          decoder =
            generate value

          from =
            node.mappings[key]? || key

          field =
            js.variable_of(node.name, key)

          <<-JS
          let #{field} = Decoder.field(`#{from}`, #{decoder})(_input)
          if (#{field} instanceof Err) { return #{field} }
          JS
        end

      fields =
        node
          .fields
          .keys
          .map do |key|
            field =
              js.variable_of(node.name, key)

            "#{field}: #{field}.value"
          end

      body =
        <<-JS
        #{consts.join("\n\n")}

        return new Ok(new #{js.class_of(node.name)}({
        #{fields.join(",\n").indent}
        }))
        JS

      @decoders[node] =
        <<-JS
        ((_input) => {
        #{body.indent}
        })
        JS
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

      "#{js.class_of(node.name)}.decode"
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
