module Mint
  class Parser
    syntax_error ConnectExpectedOpeningBracket
    syntax_error ConnectExpectedClosingBracket
    syntax_error ConnectExpectedExposing
    syntax_error ConnectExpectedType
    syntax_error ConnectExpectedKeys

    def connect : Ast::Connect | Nil
      start do |start_position|
        skip unless keyword "connect"
        whitespace

        store = type_id! ConnectExpectedType
        whitespace

        keyword! "exposing", ConnectExpectedExposing

        keys = block(
          opening_bracket: ConnectExpectedOpeningBracket,
          closing_bracket: ConnectExpectedClosingBracket
        ) do
          items = list(terminator: '{', separator: ',') { connect_variable }.compact
          raise ConnectExpectedKeys if items.empty?
          items
        end

        Ast::Connect.new(
          from: start_position,
          store: store,
          to: position,
          input: data,
          keys: keys)
      end
    end
  end
end
