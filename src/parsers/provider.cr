module Mint
  class Parser
    syntax_error ProviderExpectedOpeningBracket
    syntax_error ProviderExpectedClosingBracket
    syntax_error ProviderExpectedSubscription
    syntax_error ProviderExpectedColon
    syntax_error ProviderExpectedName
    syntax_error ProviderExpectedBody

    def provider : Ast::Provider?
      start do |start_position|
        comment = self.comment

        skip unless keyword "provider"
        whitespace

        name = type_id! ProviderExpectedName
        whitespace

        char ':', ProviderExpectedColon

        whitespace
        subscription = type_id! ProviderExpectedSubscription

        body = block(
          opening_bracket: ProviderExpectedOpeningBracket,
          closing_bracket: ProviderExpectedClosingBracket
        ) do
          items = many { function || state || self.comment }.compact
          raise ProviderExpectedBody if items
                                          .select(Ast::Function)
                                          .empty?
          items
        end

        functions = [] of Ast::Function
        comments = [] of Ast::Comment
        states = [] of Ast::State

        body.each do |item|
          case item
          when Ast::Function
            functions << item

            item.keep_name = true if item.name.value == "update"
          when Ast::State
            states << item
          when Ast::Comment
            comments << item
          else
            # ignore
          end
        end

        Ast::Provider.new(
          subscription: subscription,
          functions: functions,
          from: start_position,
          comments: comments,
          comment: comment,
          states: states,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
