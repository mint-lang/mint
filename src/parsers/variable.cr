module Mint
  class Parser
    def variable_constant(*, track = true) : Ast::Variable?
      parse(track: track) do |start_position|
        next unless value = identifier_constant

        Ast::Variable.new(
          from: start_position,
          value: value,
          to: position,
          file: file)
      end
    end

    def variable(*, track = true, extra_chars = [] of Char) : Ast::Variable?
      parse(track: track) do |start_position|
        value = gather do
          next unless char.ascii_lowercase?
          chars { |char| char.ascii_letter? || char.ascii_number? || char.in?(extra_chars) }
        end

        next unless value

        Ast::Variable.new(
          from: start_position,
          value: value,
          to: position,
          file: file)
      end
    end
  end
end
