module Mint
  class Parser
    syntax_error EnumExpectedClosingParentheses
    syntax_error EnumExpectedOpeningBracket
    syntax_error EnumExpectedClosingBracket
    syntax_error EnumExpectedName

    def enum
      start do |start_position|
        comment = self.comment

        skip unless keyword "enum"
        whitespace

        name = type_id! EnumExpectedName
        whitespace

        parameters = [] of Ast::TypeVariable

        if char! '('
          whitespace

          parameters.concat list(
            terminator: ')',
            separator: ','
          ) { type_variable }.compact

          whitespace
          char ')', EnumExpectedClosingParentheses
        end

        body = block(
          opening_bracket: EnumExpectedOpeningBracket,
          closing_bracket: EnumExpectedClosingBracket
        ) do
          many { enum_option || self.comment }.compact
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

        self << Ast::Enum.new(
          parameters: parameters,
          from: start_position,
          comments: comments,
          comment: comment,
          options: options,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
