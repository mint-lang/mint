module Mint
  class Parser
    def provide : Ast::Provide?
      parse do |start_position|
        next unless keyword! "provide"
        whitespace

        fields =
          brackets(
            -> { error :provide_expected_opening_bracket do
              expected "the opening bracket of the values of a provide", word
              snippet self
            end },
            -> { error :provide_expected_closing_bracket do
              expected "the closing bracket of the values of a provide", word
              snippet self
            end },
            ->(items : Array(Ast::Field)) {
              error :provide_expected_field do
                expected "a value of a provide", word
                snippet self
              end if items.empty?
            }) do
            list(terminator: '}', separator: ',') { field }
          end

        next unless fields
        whitespace

        body =
          block(
            -> { error :provide_expected_body_opening_bracket do
              expected "the opening bracket of the body of a provide", word
              snippet self
            end },
            -> { error :provide_expected_body_closing_bracket do
              expected "the closing bracket of the body of a provide", word
              snippet self
            end },
            -> { error :provide_expected_expression do
              expected "the body of a provide", word
              snippet self
            end })

        next unless body

        Ast::Provide.new(
          from: start_position,
          fields: fields,
          to: position,
          file: file,
          body: body)
      end
    end
  end
end
