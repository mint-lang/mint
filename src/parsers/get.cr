module Mint
  class Parser
    def get : Ast::Get?
      parse do |start_position|
        comment = self.comment

        next unless word! "get"
        whitespace

        next error :get_expected_name do
          expected "the name of a get", word
          snippet self
        end unless name = variable track: false
        whitespace

        type =
          if char! ':'
            whitespace
            next error :get_expected_type do
              expected "the type of a get", word
              snippet self
            end unless item = self.type || type_variable
            whitespace
            item
          end

        body =
          block(->{ error :get_expected_opening_bracket do
            expected "the opening bracket of a get", word
            snippet self
          end },
            ->{ error :get_expected_closing_bracket do
              expected "the closing bracket of a get", word
              snippet self
            end },
            ->{ error :get_expected_expression do
              expected "the body of a get", word
              snippet self
            end })

        next unless body

        Ast::Get.new(
          from: start_position,
          comment: comment,
          to: position,
          file: file,
          name: name,
          body: body,
          type: type)
      end
    end
  end
end
