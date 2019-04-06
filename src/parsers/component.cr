module Mint
  class Parser
    syntax_error ComponentExpectedOpeningBracket
    syntax_error ComponentExpectedClosingBracket
    syntax_error ComponentExpectedBody
    syntax_error ComponentExpectedName

    def component : Ast::Component | Nil
      start do |start_position|
        comment = self.comment

        skip unless keyword "component"
        whitespace

        name = type_id! ComponentExpectedName

        # Clear refs here beacuse it's on the parser
        refs.clear

        body = block(
          opening_bracket: ComponentExpectedOpeningBracket,
          closing_bracket: ComponentExpectedClosingBracket
        ) do
          items = many do
            property ||
              connect ||
              function ||
              style ||
              state ||
              use ||
              get ||
              self.comment
          end.compact

          raise ComponentExpectedBody if items.empty?

          items
        end

        properties = [] of Ast::Property
        functions = [] of Ast::Function
        connects = [] of Ast::Connect
        comments = [] of Ast::Comment
        styles = [] of Ast::Style
        states = [] of Ast::State
        gets = [] of Ast::Get
        uses = [] of Ast::Use

        body.each do |item|
          case item
          when Ast::Property
            properties << item
          when Ast::Function
            functions << item

            item.keep_name = true if item.name.value == "render"
          when Ast::Connect
            connects << item
          when Ast::Style
            styles << item
          when Ast::Comment
            comments << item
          when Ast::State
            states << item
          when Ast::Get
            gets << item
          when Ast::Use
            uses << item
          end
        end

        Ast::Component.new(
          properties: properties,
          functions: functions,
          from: start_position,
          connects: connects,
          comments: comments,
          comment: comment,
          styles: styles,
          states: states,
          to: position,
          input: data,
          name: name,
          uses: uses,
          gets: gets,
          refs: refs
        )
      end
    end
  end
end
