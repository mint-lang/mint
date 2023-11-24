module Mint
  class TypeChecker
    EXPOSED_BUILTINS = %w(
      decodeBoolean decodeNumber decodeString decodeArray decodeField decodeMaybe
      decodeTime locale normalizeEvent createPortal testContext testRender
      setLocale navigate compare nothing just err ok)

    def check(node : Ast::Builtin) : Checkable
      error! :unkown_builtin do
        block do
          text "There is no builtin with the name:"
          bold node.value
        end

        snippet node
      end unless node.value.in?(EXPOSED_BUILTINS)

      VOID
    end
  end
end
