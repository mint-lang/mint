module Mint
  class Parser
    syntax_error EnumExpectedOpeningBracket
    syntax_error EnumExpectedClosingBracket
    syntax_error EnumExpectedName

    def enum
      start do |start_position|
        return unless keyword "enum"

        whitespace
        name = type_id! EnumExpectedName

        body = block(
          opening_bracket: EnumExpectedOpeningBracket,
          closing_bracket: EnumExpectedClosingBracket
        ) do
          many { enum_option || comment }.compact
        end

        options = [] of Ast::EnumOption
        comments = [] of Ast::Comment

        body.each do |item|
          case item
          when Ast::EnumOption
            options << item
          when Ast::Comment
            comments << item
          end
        end

        Ast::Enum.new(
          from: start_position,
          comments: comments,
          options: options,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
