message OperationPipeAmbiguous do
  title "Type Error"

  block do
    text "We cannot determine the order of the operands becuase the pipe makes it ambiguous."
  end

  block do
    text "You sould add parentheses around the right operands."
  end

  snippet node
end
