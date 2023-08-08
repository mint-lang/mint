module Mint
  class Parser
    def state : Ast::State?
      parse do |start_position|
        comment = self.comment
        whitespace

        next unless word! "state"
        whitespace

        next error :state_expected_name do
          expected "the name of a state", word
          snippet self
        end unless name = variable
        whitespace

        type =
          if char! ':'
            whitespace
            next error :state_expected_type do
              expected "the type value of a state", word
              snippet self
            end unless item = self.type
            whitespace
            item
          end

        whitespace
        next error :state_expected_equal_sign do
          expected "the equal sign of a state", word
          snippet self
        end unless char! '='

        whitespace
        next error :state_expected_default_value do
          expected "the default value of a state", word
          snippet self
        end unless default = expression

        Ast::State.new(
          from: start_position,
          default: default,
          comment: comment,
          to: position,
          file: file,
          type: type,
          name: name)
      end
    end
  end
end
