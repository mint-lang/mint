module Mint
  class Parser
    def store : Ast::Store?
      parse do |start_position, start_nodes_position|
        comment = self.comment
        whitespace

        next unless keyword! "store"
        whitespace

        next error :store_expected_name do
          expected "the name of a store", word
          snippet self
        end unless name = id
        whitespace

        body =
          brackets(
            ->{ error :store_expected_opening_bracket do
              expected "the opening bracket of a store", word
              snippet self
            end },
            ->{ error :store_expected_closing_bracket do
              expected "the closing bracket of a store", word
              snippet self
            end },
            ->(items : Array(Ast::Node)) {
              error :store_expected_body do
                expected "the body of a store", word
                snippet self
              end if items.all?(Ast::Comment)
            }) { many { state || function || get || constant || self.comment } }

        next unless body

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

        Ast::Store.new(
          functions: functions,
          from: start_position,
          constants: constants,
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
