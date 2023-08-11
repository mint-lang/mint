module Mint
  class Parser
    def property : Ast::Property?
      start do
        comment = self.comment
        whitespace

        start_position = position

        next unless keyword "property"
        whitespace

        next error :property_expected_name do
          expected "the name of a property", word
          snippet self
        end unless name = variable track: false
        whitespace

        type =
          if char! ':'
            whitespace
            next error :property_expected_type do
              expected "the type of a property", word
              snippet self
            end unless item = self.type
            whitespace
            item
          end

        default =
          if char! '='
            whitespace
            next error :property_expected_default_value do
              expected "the default value of a property", word
              snippet self
            end unless item = expression
            item
          end

        self << Ast::Property.new(
          from: start_position,
          default: default,
          comment: comment,
          to: position,
          input: data,
          type: type,
          name: name)
      end
    end
  end
end
