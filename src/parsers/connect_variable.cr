module Mint
  class Parser
    def connect_variable
      parse do |start_position|
        next unless name = variable_constant(track: false) ||
                           variable(track: false)

        whitespace
        if keyword! "as"
          whitespace

          next error :connect_variable_expected_as do
            block do
              text "The"
              bold "exposed name"
              text "of a connection"
              bold "must be specified, here is an example:"
            end

            snippet "connect Store exposing { item as name }"
            expected "the exposed name", word
            snippet self
          end unless target = variable
        end

        Ast::ConnectVariable.new(
          from: start_position,
          target: target,
          to: position,
          file: file,
          name: name)
      end
    end
  end
end
