class Parser
  syntax_error ProviderExpectedOpeningBracket
  syntax_error ProviderExpectedClosingBracket
  syntax_error ProviderExpectedSubscription
  syntax_error ProviderExpectedColon
  syntax_error ProviderExpectedName
  syntax_error ProviderExpectedBody

  def provider : Ast::Provider | Nil
    start do |start_position|
      skip unless keyword "provider"

      whitespace
      name = type_id! ProviderExpectedName

      whitespace
      char ':', ProviderExpectedColon

      whitespace
      subscription = type_id! ProviderExpectedSubscription

      functions = block(
        opening_bracket: ProviderExpectedOpeningBracket,
        closing_bracket: ProviderExpectedClosingBracket
      ) do
        items = many { function }.compact
        raise ProviderExpectedBody if items.empty?
        items
      end

      Ast::Provider.new(
        subscription: subscription,
        functions: functions,
        from: start_position,
        to: position,
        input: data,
        name: name)
    end
  end
end
