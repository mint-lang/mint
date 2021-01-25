require "../spec_helper"

describe "Language Server - Hover" do
  it "returns information about HTML elements" do
    with_workspace do |workspace|
      workspace.file "test.mint", <<-MINT
      component Test {
        fun render : Html {
          <div></div>
        }
      }
      MINT

      # TODO: Assert
      lsp(
        id: 0,
        method: "textDocument/hover",
        message: {
          textDocument: {uri: workspace.file_path("test.mint")},
          position:     {line: 2, character: 6},
        })
    end
  end
end
