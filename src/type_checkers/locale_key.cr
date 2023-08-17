module Mint
  class TypeChecker
    def check(node : Ast::LocaleKey) : Checkable
      error :translation_missing do
        block do
          text "Translations are not specified for the key:"
          bold node.value
        end

        snippet node
      end unless translations = locales[node.value]?

      scope(node) do
        result = nil

        @languages.each do |language|
          error :translation_not_translated do
            block do
              text "There is no translation for the key:"
              bold node.value
              text "in the language:"
              bold language
            end

            snippet node
          end unless value = translations[language]?

          type =
            resolve(value)

          result =
            if result
              resolved = Comparer.compare(result, type)

              error :translation_mismatch do
                block do
                  text "The type of the key"
                  bold node.value
                  text "in the language:"
                  bold language
                  text "does not match the type in another language."
                end

                expected result, type
                snippet node
              end unless resolved

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
