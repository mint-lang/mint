module Mint
  class Parser
    def types : Ast::Node?
      self.type || type_variable || tags
    end
  end
end
