module Mint
  class Parser
    def enum_destructuring
      start do |start_position|
        next unless option = type_id

        if keyword "::"
          name = option
          next error :enum_destructuring_expected_option do
            expected "the the type of an enum destructuring", word
            snippet self
          end unless option = type_id
        end

        parameters = [] of Ast::Node

        if char! '('
          parameters.concat list(
            terminator: ')',
            separator: ','
          ) { destructuring }

          whitespace
          next error :enum_destructuring_expected_closing_parenthesis do
            expected "the the closing parenthesis of an enum destructuring", word
            snippet self
          end unless char! ')'
        end

        self << Ast::EnumDestructuring.new(
          parameters: parameters,
          from: start_position,
          option: option,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
