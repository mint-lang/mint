module Mint
  class Parser
    def state_setter : Ast::StateSetter?
      parse do |start_position|
        next unless word! "->"
        whitespace

        next error :state_setter_expected_dot do
          expected "the dot of between the entity and the state of a state setter", word
          snippet self
        end if (entity = id) && !char!('.')

        next error :state_setter_expected_variable do
          expected "the state of state setter", word
          snippet self
        end unless state = variable

        Ast::StateSetter.new(
          from: start_position,
          entity: entity,
          state: state,
          to: position,
          file: file)
      end
    end
  end
end
