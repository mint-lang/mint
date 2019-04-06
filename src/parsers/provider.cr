module Mint
  class Parser
    syntax_error ProviderExpectedOpeningBracket
    syntax_error ProviderExpectedClosingBracket
    syntax_error ProviderExpectedSubscription
    syntax_error ProviderExpectedColon
    syntax_error ProviderExpectedName
    syntax_error ProviderExpectedBody

    def provider : Ast::Provider | Nil
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
          items = many { function || self.comment }.compact
          raise ProviderExpectedBody if items
                                          .select(&.is_a?(Ast::Function))
                                          .empty?
          items
        end

        functions = [] of Ast::Function
        comments = [] of Ast::Comment

        body.each do |item|
          case item
          when Ast::Function
            functions << item

            item.keep_name = true if item.name.value == "attach" || item.name.value == "detach"
          when Ast::Comment
            comments << item
          end
        end

        Ast::Provider.new(
          subscription: subscription,
          functions: functions,
          from: start_position,
          comments: comments,
          comment: comment,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
