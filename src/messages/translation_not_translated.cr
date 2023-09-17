message TranslationNotTranslated do
  title "Type Error"

  block do
    text "There is no translation for the key:"
    bold value
    text "in the language:"
    bold language
  end

  snippet node
end
