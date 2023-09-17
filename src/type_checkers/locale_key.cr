module Mint
  class TypeChecker
    type_error TranslationNotTranslated
    type_error TranslationMismatch
    type_error TranslationMissing

    def check(node : Ast::LocaleKey) : Checkable
      raise TranslationMissing, {
        "value" => node.value,
        "node"  => node,
      } unless translations = locales[node.value]?

      scope(node) do
        result = nil

        @languages.each do |language|
          raise TranslationNotTranslated, {
            "value"    => node.value,
            "language" => language,
            "node"     => node,
          } unless value = translations[language]?

          type =
            resolve(value)

          result =
            if result
              resolved = Comparer.compare(result, type)

              raise TranslationMismatch, {
                "value"    => node.value,
                "language" => language,
                "expected" => result,
                "got"      => type,
                "node"     => node,
              } unless resolved

              resolved
            else
              type
            end
        end

        result.not_nil!
      end
    end
  end
end
