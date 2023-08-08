module Mint
  class TypeChecker
    def check(node : Ast::LocaleKey) : Checkable
      error! :translation_missing do
        snippet "Translations are not specified for this key:", node
      end unless translations = locales[node.value]?

      result = nil

      @languages.each do |language|
        error! :translation_not_translated do
          block do
            text "There is no translation for the key"
            bold %("#{node.value}")
            text "in the language"
            bold %("#{language}".)
          end

          snippet "The locale key in question is here:", node
        end unless value = translations[language]?

        type =
          resolve(value)

        result =
          if result
            resolved = Comparer.compare(result[0], type)

            error! :translation_mismatch do
              block do
                text "The type of the key"
                bold %("#{node.value}")
                text "in the language"
                bold %("#{language}")
                text "does not match the type in language"
                bold %("#{result[1]}".)
              end

              expected result[0], type
              snippet %(The defined value in language "#{language}" is here:), value
              snippet %(The defined value in language "#{result[1]}" is here:), result[2]
              snippet "The locale key in question is here:", node
            end unless resolved

            {resolved, language, value}
          else
            {type, language, value}
          end
      end

      result.not_nil![0]
    end
  end
end
