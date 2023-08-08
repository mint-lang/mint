module Mint
  class Parser
    def provider : Ast::Provider?
      parse do |start_position, start_nodes_position|
        comment = self.comment

        next unless word! "provider"
        whitespace

        next error :provider_expected_name do
          expected "the name of a provider", word
          snippet self
        end unless name = id
        whitespace

        next error :provider_expeceted_colon do
          expected "the colon of a provider", word
          snippet self
        end unless char! ':'
        whitespace

        next error :provider_expected_subscription do
          expected "the subscription type of a provider", word
          snippet self
        end unless subscription = id
        whitespace

        body = brackets(
          ->{ error :provider_expected_opening_bracket do
            expected "the opening bracket of a provider", word
            snippet self
          end },
          ->{ error :provider_expected_closing_bracket do
            expected "the closing bracket of a provider", word
            snippet self
          end },
          ->(items : Array(Ast::Node)) {
            error :provider_expected_body do
              expected "the body of a provider", word
              snippet self
            end if items.reject(Ast::Comment).empty?
          }) { many { function || state || get || constant || self.comment } }

        next unless body

        functions = [] of Ast::Function
        constants = [] of Ast::Constant
        comments = [] of Ast::Comment
        states = [] of Ast::State
        gets = [] of Ast::Get

        body.each do |item|
          case item
          when Ast::Function
            functions << item
          when Ast::Constant
            constants << item
          when Ast::Comment
            comments << item
          when Ast::State
            states << item
          when Ast::Get
            gets << item
          end
        end

        ast.nodes[start_nodes_position...].each do |node|
          case node
          when Ast::Function
            node.keep_name = true if node.name.value == "update"
          end
        end

        Ast::Provider.new(
          subscription: subscription,
          functions: functions,
          constants: constants,
          from: start_position,
          comments: comments,
          comment: comment,
          states: states,
          to: position,
          file: file,
          gets: gets,
          name: name
        ).tap do |node|
          ast.nodes[start_nodes_position...]
            .select(Ast::NextCall)
            .each(&.entity=(node))
        end
      end
    end
  end
end
