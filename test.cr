require "./src/terminal"

Render::Terminal.stdout.render do
  block "Syntax Error" do
    text "I was looking for the name of the field of the record but found "
    code ";"
    text " instead."
  end
end
