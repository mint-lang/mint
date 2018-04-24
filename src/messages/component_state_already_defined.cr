message ComponentStateAlreadyDefined do
  title "Type Error"

  block do
    text "The state of a component is defined in multiple places."
  end

  snippet node, "One is defined here:"
  snippet other, "An other is defined here:"
end
