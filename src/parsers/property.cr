module Mint
  class Parser
    def property : Ast::Property?
      parse do |start_position|
        comment = self.comment
        whitespace

        next unless keyword! "property"
        whitespace

        next error :property_expected_name do
          expected "the name of a property", word
          snippet self
        end unless name = variable track: false

        type =
          parse(track: false) do
            whitespace
            next unless char! ':'
            whitespace

            next error :property_expected_type do
              expected "the type of a property", word
              snippet self
            end unless item = self.type
            item
          end

        default =
          parse(track: false) do
            whitespace
            next unless char! '='
            whitespace

            next error :property_expected_default_value do
              expected "the default value of a property", word
              snippet self
            end unless item = expression
            item
          end

        Ast::Property.new(
          from: start_position,
          default: default,
          comment: comment,
          to: position,
          file: file,
          type: type,
          name: name)
      end
    end
  end
end
