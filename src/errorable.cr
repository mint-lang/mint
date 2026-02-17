module Mint
  # This module is used in all of things which can error out (parser, type
  # checker, scope builder, etc...)
  module Errorable
    def unreachable!(message : String)
      error! :unreachable do
        block do
          text "You have run into unreachable code."
          text "Please create an issue about this!"
        end

        snippet message
        snippet "This is the stack trace:", caller.join("\n")
      end
    end

    def error!(name : Symbol, &)
      raise Error.new(name).tap { |error| with error yield }
    end
  end
end
