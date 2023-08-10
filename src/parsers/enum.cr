module Mint
  class Parser
    def enum
      start do |start_position|
        comment = self.comment

        next unless keyword "enum"
        whitespace

        next error :enum_expected_name do
          expected "the name of an enum", word
          snippet self
        end unless name = type_id
        whitespace

        parameters = [] of Ast::TypeVariable

        if char! '('
          whitespace

          parameters.concat list(
            terminator: ')',
            separator: ','
          ) { type_variable }

          whitespace
          next error :enum_expected_closing_parenthesis do
            expected "the closing parenthesis of an enum", word
            snippet self
          end unless char! ')'
        end

        body =
          block2(
            ->{
              error :enum_expected_opening_bracket do
                expected "the opening bracket of an enum", word
                snippet self
              end
            },
            ->{
              error :enum_expected_closing_bracket do
                expected "the closing bracket of an enum", word
                snippet self
              end
            }) do
            many { enum_option || self.comment }
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
