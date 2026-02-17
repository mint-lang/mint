module Mint
  module Warnable
    getter warnings = [] of Warning

    def warning!(name : Symbol, &)
      warnings << Warning.new(name).tap { |warning| with warning yield }
    end
  end
end
