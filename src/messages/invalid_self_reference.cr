message InvalidSelfReference do
  title "Type Error"

  block do
    text "You are trying to reference an other entity in a top level entity before it is initialized."
  end

  snippet referee, "Then entity you are referencing:"
  snippet node, "The entity you are referencing from:"
end
