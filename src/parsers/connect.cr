module Mint
  class Parser
    def connect : Ast::Connect?
      start do |start_position|
        next unless keyword "connect"
        whitespace

        next error :connect_expected_store do
          expected "the name of the store for a connect", word
          snippet self
        end unless store = type_id
        whitespace

        next error :connect_expected_exposing do
          expected "the exposing keyword for a connect", word
          snippet self
        end unless keyword "exposing"

        keys = block2(
          ->{ error :connect_expected_opening_bracket do
            expected "the opening bracket of a connect", word
            snippet self
          end },
          ->{ error :connect_expected_closing_bracket do
            expected "the closing bracket of a connect", word
            snippet self
          end }
        ) do
          list(terminator: '{', separator: ',') do
            connect_variable
          end.tap do |items|
            next error :connect_expected_keys do
              expected "the exposed entities of a connect", word
              snippet self
            end if items.empty?
          end
        end

        self << Ast::Connect.new(
          from: start_position,
          store: store,
          to: position,
          input: data,
          keys: keys)
      end
    end
  end
end
