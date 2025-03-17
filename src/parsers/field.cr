module Mint
  class Parser
    def field(*, key_required : Bool = true, discard : Bool = false) : Ast::Field?
      parse do |start_position|
        comment = self.comment
        whitespace

        key =
          parse(track: false) do
            next unless item = variable
            whitespace

            next unless char! ':'
            whitespace

            item
          end

        next if key_required && !key

        next unless value =
                      if discard
                        self.discard || expression
                      else
                        expression
                      end

        Ast::Field.new(
          from: start_position,
          comment: comment,
          value: value,
          to: position,
          file: file,
          key: key)
      end
    end
  end
end
