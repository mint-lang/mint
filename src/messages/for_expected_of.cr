message ForExpectedOf do
  title "Syntax Error"

  block do
    text "The arguments of a "
    bold "for expression"
    text "and its subject must be separated with"
    bold "of keyword."
  end

  was_looking_for "the of keyword", got

  snippet node
end
