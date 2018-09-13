module Mint
  class Parser
    def comment : Ast::Comment | Nil
      inline_comment || block_comment
    end
  end
end
