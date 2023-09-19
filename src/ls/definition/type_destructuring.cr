module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::TypeDestructuring, server : Server, workspace : Workspace, stack : Array(Ast::Node))
      end
    end
  end
end
