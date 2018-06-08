message DecodeExpectedObject do
  title "Type Error"

  block do
    text "Only"
    code "Object"
    text "types can be decoded!"
  end

  was_expecting_type expected, got

  snippet node
end
