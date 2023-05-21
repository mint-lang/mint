message ReturnCallInvalid do
  title "Type Error"

  block do
    text "A"
    bold "return call "
    text "can only appear in a block as part of an or operation while destructuring or as a standalone expression."
  end

  snippet node
end
