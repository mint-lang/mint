message OperationPipeAmbiguous do
  title "Type Error"

  block do
    text "We cannot determine the order of the operands because the pipe makes it ambiguous."
  end

  block do
    text "Wrap operands in parentheses to avoid ambiguity."
  end

  snippet node
end
