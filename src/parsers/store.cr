module Mint
  class Parser
    def store : Ast::Store?
      start do |start_position|
        comment = self.comment
        whitespace

        next unless keyword "store"
        whitespace

        next error :store_expected_name do
          expected "the name of a store", word
          snippet self
        end unless name = type_id

        body =
          block2(
            ->{ error :store_expected_opening_bracket do
              expected "the opening bracket of a store", word
              snippet self
            end },
            ->{ error :store_expected_closing_bracket do
              expected "the closing bracket of a store", word
              snippet self
            end }) do
            items = many { state || function || get || constant || self.comment }

            if items.none?(Ast::Function | Ast::Constant | Ast::State | Ast::Get)
              next error :store_expected_body do
                expected "the body of a store", word
                snippet self
              end
            end

            items
          end

        functions = [] of Ast::Function
        constants = [] of Ast::Constant
        comments = [] of Ast::Comment
        states = [] of Ast::State
        gets = [] of Ast::Get

        body.each do |item|
          case item
          when Ast::Constant
            constants << item
          when Ast::Function
            functions << item
          when Ast::Comment
            comments << item
          when Ast::State
            states << item
          when Ast::Get
            gets << item
          end
        end

        self << Ast::Store.new(
          functions: functions,
          from: start_position,
          constants: constants,
          comments: comments,
          comment: comment,
          states: states,
          to: position,
          input: data,
          gets: gets,
          name: name)
      end
    end
  end
end
