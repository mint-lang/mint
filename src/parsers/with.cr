module Mint
  class Parser
    def with_expression : Ast::With?
      parse do |start_position|
        next unless keyword! "with"
        whitespace

        items = list(terminator: '{', separator: ',') { with_item }

        next error :with_expected_item do
          expected "the name of a value", word
          snippet self
        end if items.empty?
        whitespace

        body =
          block(
            -> { error :with_expected_opening_bracket do
              expected "the opening bracket of a with", word
              snippet self
            end },
            -> { error :with_expected_closing_bracket do
              expected "the closing bracket of a with", word
              snippet self
            end },
            -> { error :with_expected_expression do
              expected "the body of a with", word
              snippet self
            end })

        next unless body

        Ast::With.new(
          from: start_position,
          to: position,
          items: items,
          file: file,
          body: body)
      end
    end

    # A `with` member of a component: makes a provided value available in
    # the whole component (`with ui : Ui`).
    def with_member : Ast::WithItem?
      with_item(member: true)
    end

    def with_item(*, member : Bool = false) : Ast::WithItem?
      parse do |start_position|
        if member
          next unless keyword! "with"
          whitespace

          next error :with_expected_item do
            expected "the name of a value", word
            snippet self
          end unless name = variable
        else
          next unless name = variable
        end

        whitespace

        next error :with_expected_colon do
          expected "the colon of a with", word
          snippet self
        end unless char! ':'
        whitespace

        next error :with_expected_type do
          expected "the type of a value", word
          snippet self
        end unless type = self.type

        Ast::WithItem.new(
          from: start_position,
          to: position,
          name: name,
          file: file,
          type: type)
      end
    end
  end
end
