module Mint
  class Parser
    def map : Ast::Map?
      parse do |start_position|
        next unless char! '{'

        fields = [] of Ast::MapField

        unless char! '}'
          whitespace
          fields = list(terminator: '}', separator: ',') { map_field }
          whitespace

          next unless char! '}'
        end

        types =
          parse do
            whitespace
            next unless word! "of"

            whitespace
            next error :map_expected_key_type do
              expected "the type of the keys of a map", word
              snippet self
            end unless key_type = type || type_variable

            whitespace
            next error :map_expected_arrow do
              expected "the arrow for the types of a map", word
              snippet self
            end unless word! "=>"

            whitespace
            next error :map_expected_value_type do
              expected "the type of the values of a map", word
              snippet self
            end unless value_type = type || type_variable

            {key_type, value_type}
          end

        Ast::Map.new(
          from: start_position,
          fields: fields,
          types: types,
          to: position,
          file: file)
      end
    end
  end
end
