module Mint
  class Parser
    def locale_key : Ast::LocaleKey?
      parse do |start_position|
        next unless char! ':'

        value = gather do
          next unless char.ascii_lowercase?
          ascii_letters_or_numbers(extra_char: '.')
        end

        next unless value

        Ast::LocaleKey.new(
          from: start_position,
          value: value,
          to: position,
          file: file)
      end
    end
  end
end
