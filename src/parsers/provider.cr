module Mint
  class Parser
    def provider : Ast::Provider?
      start do |start_position|
        comment = self.comment

        next unless keyword "provider"
        whitespace

        next error :provider_expected_name do
          expected "the name of a provider", word
          snippet self
        end unless name = type_id
        whitespace

        next error :provider_expeceted_colon do
          expected "the colon of a provider", word
          snippet self
        end unless char! ':'

        whitespace
        next error :provider_expected_subscription do
          expected "the subscription type of a provider", word
          snippet self
        end unless subscription = type_id

        body = block2(
          ->{ error :provider_expected_opening_bracket do
            expected "the opening bracket of a provider", word
            snippet self
          end },
          ->{ error :provider_expected_closing_bracket do
            expected "the closing bracket of a provider", word
            snippet self
          end }
        ) do
          items = many { function || state || get || constant || self.comment }

          next error :provider_expected_body do
            expected "the body of a provider", word
            snippet self
          end if items.reject(Ast::Comment).empty?

          items
        end

        functions = [] of Ast::Function
        constants = [] of Ast::Constant
        comments = [] of Ast::Comment
        states = [] of Ast::State
        gets = [] of Ast::Get

        body.each do |item|
          case item
          when Ast::Function
            functions << item

            item.keep_name = true if item.name.value == "update"
          when Ast::State
            states << item
          when Ast::Constant
            constants << item
          when Ast::Comment
            comments << item
          when Ast::Get
            gets << item
          end
        end

        self << Ast::Provider.new(
          subscription: subscription,
          functions: functions,
          constants: constants,
          from: start_position,
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
