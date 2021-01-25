module Mint
  class Parser
    syntax_error ComponentExpectedOpeningBracket
    syntax_error ComponentExpectedClosingBracket
    syntax_error ComponentExpectedBody
    syntax_error ComponentExpectedName

    def component : Ast::Component?
      start do |start_position|
        comment = self.comment

        global = keyword "global"
        whitespace

        skip unless keyword "component"
        whitespace

        name = type_id! ComponentExpectedName

        # Clear refs here because it's on the parser
        refs.clear

        body = block(
          opening_bracket: ComponentExpectedOpeningBracket,
          closing_bracket: ComponentExpectedClosingBracket
        ) do
          items = many do
            property ||
              connect ||
              constant ||
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
        constants = [] of Ast::Constant
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
          when Ast::Constant
            constants << item
          when Ast::Connect
            connects << item
          when Ast::Comment
            comments << item
          when Ast::Style
            styles << item
          when Ast::State
            states << item
          when Ast::Get
            gets << item
          when Ast::Use
            uses << item
          else
            # ignore
          end
        end

        self << Ast::Component.new(
          global: global || false,
          properties: properties,
          functions: functions,
          constants: constants,
          from: start_position,
          connects: connects,
          comments: comments,
          comment: comment,
          styles: styles,
          states: states,
          refs: refs.dup,
          to: position,
          input: data,
          name: name,
          uses: uses,
          gets: gets
        )
      end
    end
  end
end
