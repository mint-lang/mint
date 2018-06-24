module Mint
  class Parser
    syntax_error StoreExpectedOpeningBracket
    syntax_error StoreExpectedClosingBracket
    syntax_error StoreExpectedBody
    syntax_error StoreExpectedName

    def store : Ast::Store | Nil
      start do |start_position|
        comment = self.comment
        whitespace

        skip unless keyword "store"
        whitespace

        name = type_id! StoreExpectedName

        body = block(
          opening_bracket: StoreExpectedOpeningBracket,
          closing_bracket: StoreExpectedClosingBracket
        ) do
          items = many { property || function || get || self.comment }.compact

          raise StoreExpectedBody if items
                                       .reject(&.is_a?(Ast::Comment))
                                       .empty?
          items
        end

        properties = [] of Ast::Property
        functions = [] of Ast::Function
        comments = [] of Ast::Comment
        gets = [] of Ast::Get

        body.each do |item|
          case item
          when Ast::Property
            properties << item
          when Ast::Function
            functions << item
          when Ast::Comment
            comments << item
          when Ast::Get
            gets << item
          end
        end

        Ast::Store.new(
          properties: properties,
          functions: functions,
          from: start_position,
          comments: comments,
          comment: comment,
          to: position,
          input: data,
          gets: gets,
          name: name)
      end
    end
  end
end
