module Mint
  class Parser
    def component : Ast::Component?
      parse do |start_position, start_nodes_position|
        comment = self.comment
        whitespace

        global = keyword! "global"
        whitespace

        async = keyword! "async"
        whitespace

        next unless keyword! "component"
        whitespace

        next error :component_expected_name do
          block do
            text "The name of a component must start with an uppercase letter"
            text "and only contain lowercase, uppercase letters and numbers."
          end

          expected "name of the component", word
          snippet self
        end unless name = id
        whitespace

        body = brackets(
          ->{ error :component_expected_opening_bracket do
            expected "the opening bracket of the component", word
            snippet self
          end },
          ->{ error :component_expected_closing_bracket do
            expected "the closing bracket of the component", word
            snippet self
          end },
          ->(items : Array(Ast::Node)) {
            error :component_expected_body do
              expected "the body of a component", word
              snippet self
            end if items.reject(Ast::Comment).empty?
          }
        ) do
          many do
            property ||
              constant ||
              function ||
              connect ||
              style ||
              state ||
              use ||
              get ||
              self.comment
            # ^^ This needs to be last because it can eat the documentation
            # comment of the sub entities.
          end
        end

        next unless body

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
          end
        end

        refs = [] of Tuple(Ast::Variable, Ast::Node)
        locales = false

        ast.nodes[start_nodes_position...].each do |node|
          case node
          when Ast::LocaleKey
            locales = true
          when Ast::Function
            if node.name.value.in?([
                 "componentWillUnmount",
                 "componentDidUpdate",
                 "componentDidMount",
                 "render",
               ])
              node.keep_name = true
            end
          when Ast::HtmlElement
            node.styles.each do |style|
              style.style_node =
                styles.find(&.name.value.==(style.name.value))
            end
          end

          case node
          when Ast::HtmlComponent,
               Ast::HtmlElement
            node.in_component = true

            if ref = node.ref
              refs << {ref, node}
            end
          end
        end

        Ast::Component.new(
          global: global || false,
          properties: properties,
          functions: functions,
          constants: constants,
          from: start_position,
          connects: connects,
          comments: comments,
          comment: comment,
          locales: locales,
          styles: styles,
          states: states,
          async: async,
          to: position,
          file: file,
          refs: refs,
          name: name,
          uses: uses,
          gets: gets
        ).tap do |node|
          ast.nodes[start_nodes_position...]
            .select(Ast::NextCall)
            .each(&.entity=(node))
        end
      end
    end
  end
end
