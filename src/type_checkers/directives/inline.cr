module Mint
  class TypeChecker
    def check(node : Ast::Directives::Inline) : Checkable
      error :inline_directive_expected_file do
        block "The path specified for an inline directive does not exists."

        block do
          text "The file should be here: "
          bold node.real_path.to_s
        end

        snippet node
      end unless node.exists?

      STRING
    end
  end
end
