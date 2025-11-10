module Mint
  class Parser
    def types : Ast::Node?
      tags || type_variable
    end
  end
end
