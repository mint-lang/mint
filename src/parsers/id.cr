module Mint
  class Parser
    def id(*, track : Bool = true) : Ast::Id?
      parse(track: track) do |start_position|
        return unless value = identifier_type

        Ast::Id.new(
          from: start_position,
          value: value,
          to: position,
          file: file)
      end
    end
  end
end
